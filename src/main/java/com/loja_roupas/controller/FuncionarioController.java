package com.loja_roupas.controller;

import com.loja_roupas.model.Funcionario;
import com.loja_roupas.model.Usuario;
import com.loja_roupas.repository.FuncionarioRepository;
import com.loja_roupas.repository.UsuarioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/funcionarios")
public class FuncionarioController {

    public record FuncionarioRequest(Integer idUsuario, String nome, String cpf) {}
    public record FuncionarioResponse(Integer idFuncionario, Integer idUsuario, String nome, String cpf) {}

    private final FuncionarioRepository repo;
    private final UsuarioRepository usuarioRepo;

    public FuncionarioController(FuncionarioRepository repo, UsuarioRepository usuarioRepo) {
        this.repo = repo;
        this.usuarioRepo = usuarioRepo;
    }

    @PostMapping
    public ResponseEntity<FuncionarioResponse> criar(@RequestBody FuncionarioRequest req) {
        Funcionario f = new Funcionario();
        preencher(f, req);
        return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(repo.save(f)));
    }

    @GetMapping
    public List<FuncionarioResponse> listar() {
        return repo.findAll().stream().map(this::toResponse).toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<FuncionarioResponse> buscar(@PathVariable Integer id) {
        return repo.findById(id).map(f -> ResponseEntity.ok(toResponse(f)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<FuncionarioResponse> atualizar(@PathVariable Integer id, @RequestBody FuncionarioRequest req) {
        return repo.findById(id).map(f -> {
            preencher(f, req);
            return ResponseEntity.ok(toResponse(repo.save(f)));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Integer id) {
        if (!repo.existsById(id)) return ResponseEntity.notFound().build();
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    private void preencher(Funcionario f, FuncionarioRequest r) {
        if (r.idUsuario() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "idUsuario é obrigatório");
        }
        Usuario u = usuarioRepo.findById(r.idUsuario())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Usuário não encontrado: " + r.idUsuario()));
        f.setUsuario(u);
        f.setNome(r.nome());
        f.setCpf(r.cpf());
    }

    private FuncionarioResponse toResponse(Funcionario f) {
        return new FuncionarioResponse(f.getIdFuncionario(), f.getUsuario().getIdUsuario(), f.getNome(), f.getCpf());
    }
}