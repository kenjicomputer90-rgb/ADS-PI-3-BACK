package com.loja_roupas.controller;

import com.loja_roupas.dto.ProdutoRequest;
import com.loja_roupas.dto.ProdutoResponse;
import com.loja_roupas.service.ProdutoService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/produtos")
public class ProdutoController {

    private final ProdutoService service;

    public ProdutoController(ProdutoService service) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<ProdutoResponse> criar(@Valid @RequestBody ProdutoRequest req) {
        ProdutoResponse criado = service.criar(req);
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}").buildAndExpand(criado.idPeca()).toUri();
        return ResponseEntity.created(location).body(criado);
    }

    @GetMapping
    public List<ProdutoResponse> listar(@RequestParam(required = false) String descricao,
                                        @RequestParam(required = false) String tamanho,
                                        @RequestParam(required = false) String cor) {
        return service.listar(descricao, tamanho, cor);
    }

    @GetMapping("/{id}")
    public ProdutoResponse buscarPorId(@PathVariable Integer id) {
        return service.buscarPorId(id);
    }

    @GetMapping("/codigo")
    public ProdutoResponse buscarPorCodigo(@RequestParam String valor) {
        return service.buscarPorCodigo(valor);
    }

    @PutMapping("/{id}")
    public ProdutoResponse atualizar(@PathVariable Integer id,
                                     @Valid @RequestBody ProdutoRequest req) {
        return service.atualizar(id, req);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void remover(@PathVariable Integer id) {
        service.remover(id);
    }
}