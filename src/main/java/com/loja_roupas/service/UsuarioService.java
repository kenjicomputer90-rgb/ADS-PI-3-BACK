package com.loja_roupas.service;

import com.loja_roupas.model.Usuario;
import com.loja_roupas.repository.UsuarioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;

    public UsuarioService(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    public List<Usuario> listar() {
        return usuarioRepository.findAll();
    }

    public Usuario buscarPorId(Integer id) {
        return usuarioRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuário não encontrado"));
    }

    public Usuario criar(Usuario usuario) {
        if (usuarioRepository.existsByEmail(usuario.getEmail())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "E-mail já cadastrado");
        }
        usuario.setIdUsuario(null); // garante que será um INSERT
        return usuarioRepository.save(usuario);
    }

    public Usuario atualizar(Integer id, Usuario dados) {
        Usuario existente = buscarPorId(id);

        usuarioRepository.findByEmail(dados.getEmail()).ifPresent(outro -> {
            if (!outro.getIdUsuario().equals(id)) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "E-mail já cadastrado");
            }
        });

        existente.setNome(dados.getNome());
        existente.setEmail(dados.getEmail());
        existente.setSenha(dados.getSenha());
        existente.setPerfilAcesso(dados.getPerfilAcesso());

        return usuarioRepository.save(existente);
    }

    public void deletar(Integer id) {
        Usuario existente = buscarPorId(id);
        usuarioRepository.delete(existente);
    }
}