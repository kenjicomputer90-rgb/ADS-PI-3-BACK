package com.loja_roupas.controller;

import com.loja_roupas.model.Usuario;
import com.loja_roupas.repository.UsuarioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    public record UsuarioRequest(String nome, String email, String senha, String perfilAcesso) {}
    public record UsuarioResponse(Integer idUsuario, String nome, String email, String perfilAcesso) {}

    private final UsuarioRepository repo;

    public UsuarioController(UsuarioRepository repo) {
        this.repo = repo;
    }

    @PostMapping
    public ResponseEntity<UsuarioResponse> criar(@RequestBody UsuarioRequest req) {
        Usuario u = new Usuario();
        preencher(u, req);
        return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(repo.save(u)));
    }

    @GetMapping
    public List<UsuarioResponse> listar() {
        return repo.findAll().stream().map(this::toResponse).toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<UsuarioResponse> buscar(@PathVariable Integer id) {
        return repo.findById(id).map(u -> ResponseEntity.ok(toResponse(u)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<UsuarioResponse> atualizar(@PathVariable Integer id, @RequestBody UsuarioRequest req) {
        return repo.findById(id).map(u -> {
            preencher(u, req);
            return ResponseEntity.ok(toResponse(repo.save(u)));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Integer id) {
        if (!repo.existsById(id)) return ResponseEntity.notFound().build();
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    private void preencher(Usuario u, UsuarioRequest r) {
        u.setNome(r.nome());
        u.setEmail(r.email());
        u.setSenha(r.senha());
        u.setPerfilAcesso(r.perfilAcesso());
    }

    private UsuarioResponse toResponse(Usuario u) {
        return new UsuarioResponse(u.getIdUsuario(), u.getNome(), u.getEmail(), u.getPerfilAcesso());
    }
}