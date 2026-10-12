package com.loja_roupas.controller;

import com.loja_roupas.dto.LocacaoRequest;
import com.loja_roupas.dto.LocacaoResponse;
import com.loja_roupas.service.LocacaoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/locacoes")
public class LocacaoController {

    private final LocacaoService service;

    public LocacaoController(LocacaoService service) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<LocacaoResponse> criar(@RequestBody LocacaoRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.criar(request));
    }

    @GetMapping
    public List<LocacaoResponse> listar() {
        return service.listar();
    }

    @GetMapping("/{id}")
    public LocacaoResponse buscar(@PathVariable Integer id) {
        return service.buscar(id);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Integer id) {
        service.deletar(id);
        return ResponseEntity.noContent().build();
    }
}