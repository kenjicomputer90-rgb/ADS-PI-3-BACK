package com.loja_roupas.controller;

import com.loja_roupas.dto.FuncionarioResponse;
import com.loja_roupas.model.Funcionario;
import com.loja_roupas.model.Usuario;
import com.loja_roupas.repository.FuncionarioRepository;
import com.loja_roupas.repository.UsuarioRepository;
import com.loja_roupas.service.FuncionarioService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

/**
 * Rotas HTTP do módulo Funcionário (/funcionarios).
 * As consultas já passam pelo FuncionarioService.
 * Cadastrar, atualizar e excluir ainda usam o código antigo e serão trocados na Etapa 13.
 */
@RestController
@RequestMapping("/funcionarios")
public class FuncionarioController {

    // DTO antigo: só o cadastrar e o atualizar usam, até a Etapa 13
    public record FuncionarioRequest(Integer idUsuario, String nome, String cpf) {}

    private final FuncionarioService service;
    private final FuncionarioRepository repo;
    private final UsuarioRepository usuarioRepo;

    public FuncionarioController(FuncionarioService service,
                                 FuncionarioRepository repo,
                                 UsuarioRepository usuarioRepo) {
        this.service = service;
        this.repo = repo;
        this.usuarioRepo = usuarioRepo;
    }

    // ---------- consultas (já usam o service) ----------

    /** GET /funcionarios ou /funcionarios?nome=... */
    @GetMapping
    public List<FuncionarioResponse> listar(@RequestParam(required = false) String nome) {
        return service.listar(nome);
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

    // ---------- código antigo (será trocado na Etapa 13) ----------

    @PostMapping
    public ResponseEntity<FuncionarioResponse> criar(@RequestBody FuncionarioRequest req) {
        Funcionario f = new Funcionario();
        preencher(f, req);
        return ResponseEntity.status(HttpStatus.CREATED).body(FuncionarioResponse.de(repo.save(f)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<FuncionarioResponse> atualizar(@PathVariable Integer id, @RequestBody FuncionarioRequest req) {
        return repo.findById(id).map(f -> {
            preencher(f, req);
            return ResponseEntity.ok(FuncionarioResponse.de(repo.save(f)));
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
}