package com.loja_roupas.service;

import com.loja_roupas.dto.ProdutoRequest;
import com.loja_roupas.dto.ProdutoResponse;
import com.loja_roupas.exception.ConflitoException;
import com.loja_roupas.exception.RecursoNaoEncontradoException;
import com.loja_roupas.model.Produto;
import com.loja_roupas.repository.ProdutoRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ProdutoService {

    private final ProdutoRepository repository;

    public ProdutoService(ProdutoRepository repository) {
        this.repository = repository;
    }

    @Transactional
    public ProdutoResponse criar(ProdutoRequest req) {
        if (repository.existsByCodigoUnico(req.codigoUnico())) {
            throw new ConflitoException("Já existe um produto com esse código");
        }
        Produto produto = new Produto();
        preencher(produto, req);
        return ProdutoResponse.de(repository.save(produto));
    }

    @Transactional(readOnly = true)
    public ProdutoResponse buscarPorId(Integer id) {
        return ProdutoResponse.de(obter(id));
    }

    @Transactional(readOnly = true)
    public ProdutoResponse buscarPorCodigo(String codigo) {
        return repository.findByCodigoUnico(codigo)
                .map(ProdutoResponse::de)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Produto não encontrado com esse código"));
    }

    @Transactional(readOnly = true)
    public List<ProdutoResponse> listar(String descricao, String tamanho, String cor) {
        return repository.filtrar(vazioParaNulo(descricao), vazioParaNulo(tamanho), vazioParaNulo(cor))
                .stream().map(ProdutoResponse::de).toList();
    }

    @Transactional
    public ProdutoResponse atualizar(Integer id, ProdutoRequest req) {
        Produto produto = obter(id);

        repository.findByCodigoUnico(req.codigoUnico()).ifPresent(outro -> {
            if (!outro.getIdPeca().equals(id)) {
                throw new ConflitoException("Já existe outro produto com esse código");
            }
        });

        preencher(produto, req);
        return ProdutoResponse.de(repository.save(produto));
    }

    @Transactional
    public void remover(Integer id) {
        repository.delete(obter(id));
    }

    // ---------- auxiliares ----------

    private Produto obter(Integer id) {
        return repository.findById(id)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Produto não encontrado: " + id));
    }

    private String vazioParaNulo(String valor) {
        return (valor == null || valor.isBlank()) ? null : valor.trim();
    }

    private void preencher(Produto produto, ProdutoRequest req) {
        produto.setCodigoUnico(req.codigoUnico());
        produto.setDescricao(req.descricao());
        produto.setTamanho(req.tamanho());
        produto.setCor(req.cor());
        produto.setMaterial(req.material());
        produto.setPreco(req.preco());
    }
}