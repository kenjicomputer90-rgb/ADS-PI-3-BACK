package com.loja_roupas.controller;

import com.loja_roupas.dto.ClienteRequest;
import com.loja_roupas.dto.ClienteResponse;
import com.loja_roupas.service.ClienteService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/clientes")
public class ClienteController {

    private final ClienteService service;

    public ClienteController(ClienteService service) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<ClienteResponse> criar(@Valid @RequestBody ClienteRequest req) {
        ClienteResponse criado = service.criar(req);
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}").buildAndExpand(criado.idCliente()).toUri();
        return ResponseEntity.created(location).body(criado);
    }

    @GetMapping
    public List<ClienteResponse> listar(@RequestParam(required = false) String nome) {
        return service.listar(nome);
    }

    @GetMapping("/{id}")
    public ClienteResponse buscarPorId(@PathVariable Integer id) {
        return service.buscarPorId(id);
    }

    @GetMapping("/cpf")
    public ClienteResponse buscarPorCpf(@RequestParam String valor) {
        return service.buscarPorCpf(valor);
    }

    @PutMapping("/{id}")
    public ClienteResponse atualizar(@PathVariable Integer id,
                                     @Valid @RequestBody ClienteRequest req) {
        return service.atualizar(id, req);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void remover(@PathVariable Integer id) {
        service.remover(id);
    }
}