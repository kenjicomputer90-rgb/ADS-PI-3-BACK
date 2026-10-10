package com.loja_roupas.service;

import com.loja_roupas.dto.ClienteRequest;
import com.loja_roupas.dto.ClienteResponse;
import com.loja_roupas.exception.ConflitoException;
import com.loja_roupas.exception.RecursoNaoEncontradoException;
import com.loja_roupas.model.Cliente;
import com.loja_roupas.repository.ClienteRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ClienteService {

    private final ClienteRepository repository;

    public ClienteService(ClienteRepository repository) {
        this.repository = repository;
    }

    @Transactional
    public ClienteResponse criar(ClienteRequest req) {
        if (repository.existsByCpf(req.cpf())) {
            throw new ConflitoException("Já existe um cliente com esse CPF");
        }
        validarUsuarioLivre(req.idUsuario(), null);

        Cliente cliente = new Cliente();
        preencher(cliente, req);
        return ClienteResponse.de(repository.save(cliente));
    }

    @Transactional(readOnly = true)
    public ClienteResponse buscarPorId(Integer id) {
        return ClienteResponse.de(obter(id));
    }

    @Transactional(readOnly = true)
    public ClienteResponse buscarPorCpf(String cpf) {
        return repository.findByCpf(cpf)
                .map(ClienteResponse::de)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Cliente não encontrado com esse CPF"));
    }

    @Transactional(readOnly = true)
    public List<ClienteResponse> listar(String nome) {
        List<Cliente> clientes = (nome == null || nome.isBlank())
                ? repository.findAll()
                : repository.findByNomeContainingIgnoreCaseOrderByNome(nome);
        return clientes.stream().map(ClienteResponse::de).toList();
    }

    @Transactional
    public ClienteResponse atualizar(Integer id, ClienteRequest req) {
        Cliente cliente = obter(id);

        repository.findByCpf(req.cpf()).ifPresent(outro -> {
            if (!outro.getIdCliente().equals(id)) {
                throw new ConflitoException("Já existe outro cliente com esse CPF");
            }
        });
        validarUsuarioLivre(req.idUsuario(), id);

        preencher(cliente, req);
        return ClienteResponse.de(repository.save(cliente));
    }

    @Transactional
    public void remover(Integer id) {
        repository.delete(obter(id));
    }

    // ---------- auxiliares ----------

    private Cliente obter(Integer id) {
        return repository.findById(id)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Cliente não encontrado: " + id));
    }

    // id_usuario é UNIQUE: um usuário só pode estar ligado a um cliente
    private void validarUsuarioLivre(Integer idUsuario, Integer idClienteAtual) {
        if (idUsuario == null) return;
        repository.findByIdUsuario(idUsuario).ifPresent(outro -> {
            if (!outro.getIdCliente().equals(idClienteAtual)) {
                throw new ConflitoException("Esse usuário já está vinculado a outro cliente");
            }
        });
    }

    private void preencher(Cliente cliente, ClienteRequest req) {
        cliente.setNome(req.nome());
        cliente.setCpf(req.cpf());
        cliente.setTelefone(req.telefone());
        cliente.setEndereco(req.endereco());
        cliente.setRg(req.rg());
        cliente.setMedidas(req.medidas());
        cliente.setDataNascimento(req.dataNascimento());
        cliente.setIdUsuario(req.idUsuario());
    }
}