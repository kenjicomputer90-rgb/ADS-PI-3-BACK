package com.loja_roupas.service;

import com.loja_roupas.dto.FuncionarioResponse;
import com.loja_roupas.exception.RecursoNaoEncontradoException;
import com.loja_roupas.model.Funcionario;
import com.loja_roupas.repository.FuncionarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Regras de negócio do módulo Funcionário.
 * O controller chama este service, e o service usa o repository para falar com o banco.
 */
@Service
public class FuncionarioService {

    private final FuncionarioRepository repository;

    public FuncionarioService(FuncionarioRepository repository) {
        this.repository = repository;
    }

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

    // ---------- auxiliares ----------

    /** Busca a entidade pelo id ou lança 404. Usado por vários métodos deste service. */
    private Funcionario obter(Integer id) {
        return repository.findById(id)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Funcionário não encontrado: " + id));
    }
}