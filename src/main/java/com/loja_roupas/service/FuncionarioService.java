package com.loja_roupas.service;

import com.loja_roupas.dto.FuncionarioRequest;
import com.loja_roupas.dto.FuncionarioResponse;
import com.loja_roupas.exception.ConflitoException;
import com.loja_roupas.exception.RecursoNaoEncontradoException;
import com.loja_roupas.model.Funcionario;
import com.loja_roupas.model.Usuario;
import com.loja_roupas.repository.FuncionarioRepository;
import com.loja_roupas.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Regras de negócio do módulo Funcionário.
 * O controller chama este service, e o service usa os repositories para falar com o banco.
 */
@Service
public class FuncionarioService {

    private final FuncionarioRepository repository;
    private final UsuarioRepository usuarioRepository;

    public FuncionarioService(FuncionarioRepository repository, UsuarioRepository usuarioRepository) {
        this.repository = repository;
        this.usuarioRepository = usuarioRepository;
    }

    // ---------- consultas ----------

    /**
     * Lista os funcionários. Se vier um nome, filtra por ele.
     *
     * @param nome parte do nome para filtrar (opcional)
     * @return lista de funcionários no formato de resposta
     */
    @Transactional(readOnly = true)
    public List<FuncionarioResponse> listar(String nome) {
        List<Funcionario> funcionarios = (nome == null || nome.isBlank())
                ? repository.findAll()
                : repository.findByNomeContainingIgnoreCaseOrderByNome(nome);
        return funcionarios.stream().map(FuncionarioResponse::de).toList();
    }

    /**
     * Busca um funcionário pelo id.
     *
     * @param id identificador do funcionário
     * @return o funcionário encontrado
     * @throws RecursoNaoEncontradoException se o id não existir (vira HTTP 404)
     */
    @Transactional(readOnly = true)
    public FuncionarioResponse buscarPorId(Integer id) {
        return FuncionarioResponse.de(obter(id));
    }

    /**
     * Busca um funcionário pelo CPF exato.
     *
     * @param cpf CPF do funcionário
     * @return o funcionário encontrado
     * @throws RecursoNaoEncontradoException se o CPF não existir (vira HTTP 404)
     */
    @Transactional(readOnly = true)
    public FuncionarioResponse buscarPorCpf(String cpf) {
        return repository.findByCpf(cpf)
                .map(FuncionarioResponse::de)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Funcionário não encontrado com esse CPF"));
    }

    // ---------- cadastrar, atualizar e excluir ----------

    /**
     * Cadastra um funcionário novo.
     *
     * @param req dados recebidos pela API (já validados pelo @Valid)
     * @return o funcionário criado, já com o id gerado pelo banco
     * @throws ConflitoException se o CPF já existir ou o usuário já estiver em outro funcionário (HTTP 409)
     * @throws RecursoNaoEncontradoException se o usuário não existir (HTTP 404)
     */
    @Transactional
    public FuncionarioResponse criar(FuncionarioRequest req) {
        if (repository.existsByCpf(req.cpf())) {
            throw new ConflitoException("Já existe um funcionário com esse CPF");
        }
        Usuario usuario = buscarUsuarioLivre(req.idUsuario(), null);

        Funcionario funcionario = new Funcionario();
        preencher(funcionario, req, usuario);
        return FuncionarioResponse.de(repository.save(funcionario));
    }

    /**
     * Atualiza os dados de um funcionário que já existe.
     *
     * @param id  identificador do funcionário
     * @param req dados novos (já validados pelo @Valid)
     * @return o funcionário atualizado
     * @throws RecursoNaoEncontradoException se o funcionário ou o usuário não existirem (HTTP 404)
     * @throws ConflitoException se o CPF ou o usuário já pertencerem a outro funcionário (HTTP 409)
     */
    @Transactional
    public FuncionarioResponse atualizar(Integer id, FuncionarioRequest req) {
        Funcionario funcionario = obter(id);

        repository.findByCpf(req.cpf()).ifPresent(outro -> {
            if (!outro.getIdFuncionario().equals(id)) {
                throw new ConflitoException("Já existe outro funcionário com esse CPF");
            }
        });
        Usuario usuario = buscarUsuarioLivre(req.idUsuario(), id);

        preencher(funcionario, req, usuario);
        return FuncionarioResponse.de(repository.save(funcionario));
    }

    /**
     * Exclui um funcionário.
     *
     * @param id identificador do funcionário
     * @throws RecursoNaoEncontradoException se o id não existir (HTTP 404)
     */
    @Transactional
    public void remover(Integer id) {
        repository.delete(obter(id));
    }

    // ---------- auxiliares ----------

    /** Busca a entidade pelo id ou lança 404. Usado por vários métodos deste service. */
    private Funcionario obter(Integer id) {
        return repository.findById(id)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Funcionário não encontrado: " + id));
    }

    /**
     * Busca o usuário e confere se ele já não está ligado a OUTRO funcionário.
     * Na criação, idFuncionarioAtual é null, então qualquer funcionário encontrado é "outro".
     */
    private Usuario buscarUsuarioLivre(Integer idUsuario, Integer idFuncionarioAtual) {
        Usuario usuario = usuarioRepository.findById(idUsuario)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Usuário não encontrado: " + idUsuario));

        repository.findByUsuario_IdUsuario(idUsuario).ifPresent(outro -> {
            if (!outro.getIdFuncionario().equals(idFuncionarioAtual)) {
                throw new ConflitoException("Esse usuário já está vinculado a outro funcionário");
            }
        });
        return usuario;
    }

    /** Copia os dados do pedido para a entidade. Usado pelo criar e pelo atualizar. */
    private void preencher(Funcionario f, FuncionarioRequest req, Usuario usuario) {
        f.setUsuario(usuario);
        f.setNome(req.nome());
        f.setCpf(req.cpf());
        f.setRg(req.rg());
        f.setTelefone(req.telefone());
        f.setCtps(req.ctps());
        f.setDependente(req.dependente() != null ? req.dependente() : 0);
        f.setSexo(req.sexo());
        f.setSalario(req.salario());
        f.setDataNascimento(req.dataNascimento());
        f.setEstadoCivil(req.estadoCivil());
    }
}