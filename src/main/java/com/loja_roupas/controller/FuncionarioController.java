package com.loja_roupas.controller;

import com.loja_roupas.dto.FuncionarioRequest;
import com.loja_roupas.dto.FuncionarioResponse;
import com.loja_roupas.service.FuncionarioService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Rotas HTTP do módulo Funcionário (/funcionarios).
 * O controller só recebe o pedido, repassa para o FuncionarioService e devolve a resposta.
 * As regras de negócio ficam todas no service.
 */
@RestController
@RequestMapping("/funcionarios")
public class FuncionarioController {

    private final FuncionarioService service;

    public FuncionarioController(FuncionarioService service) {
        this.service = service;
    }

    /** GET /funcionarios, com filtros opcionais: ?nome=... e ?ativo=true|false */
    @GetMapping
    public List<FuncionarioResponse> listar(@RequestParam(required = false) String nome,
                                            @RequestParam(required = false) Boolean ativo) {
        return service.listar(nome, ativo);
    }

    /** GET /funcionarios/{id} */
    @GetMapping("/{id}")
    public FuncionarioResponse buscarPorId(@PathVariable Integer id) {
        return service.buscarPorId(id);
    }

    /** GET /funcionarios/cpf?valor=... */
    @GetMapping("/cpf")
    public FuncionarioResponse buscarPorCpf(@RequestParam String valor) {
        return service.buscarPorCpf(valor);
    }

    /** POST /funcionarios: cadastra e devolve 201 (Created). */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public FuncionarioResponse criar(@Valid @RequestBody FuncionarioRequest req) {
        return service.criar(req);
    }

    /** PUT /funcionarios/{id}: atualiza e devolve 200 (OK). */
    @PutMapping("/{id}")
    public FuncionarioResponse atualizar(@PathVariable Integer id,
                                         @Valid @RequestBody FuncionarioRequest req) {
        return service.atualizar(id, req);
    }

    /** PATCH /funcionarios/{id}/desativar: marca como inativo (saiu da loja, mas fica no histórico). */
    @PatchMapping("/{id}/desativar")
    public FuncionarioResponse desativar(@PathVariable Integer id) {
        return service.desativar(id);
    }

    /** PATCH /funcionarios/{id}/ativar: marca como ativo de novo. */
    @PatchMapping("/{id}/ativar")
    public FuncionarioResponse ativar(@PathVariable Integer id) {
        return service.ativar(id);
    }

    /** DELETE /funcionarios/{id}: exclui e devolve 204 (No Content). */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void remover(@PathVariable Integer id) {
        service.remover(id);
    }
}