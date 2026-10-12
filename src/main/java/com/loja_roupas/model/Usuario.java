package com.loja_roupas.model;

import jakarta.persistence.*;

@Entity
@Table(name = "usuario")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_usuario")
    private Integer idUsuario;

    @Column(name = "nome", nullable = false, length = 60)
    private String nome;

    @Column(name = "email", nullable = false, unique = true, length = 40)
    private String email;

    @Column(name = "senha", nullable = false, length = 60)
    private String senha;

    @Column(name = "perfil_acesso", nullable = false, length = 40)
    private String perfilAcesso;

    
    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }
    public String getPerfilAcesso() { return perfilAcesso; }
    public void setPerfilAcesso(String perfilAcesso) { this.perfilAcesso = perfilAcesso; }
}