package com.loja_roupas.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "cliente")
public class Cliente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_cliente")
    private Integer idCliente;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", unique = true)
    private Usuario usuario;

    @Column(name = "nome", nullable = false, length = 60)
    private String nome;

    @Column(name = "cpf", nullable = false, unique = true, length = 14)
    private String cpf;

    @Column(name = "telefone", nullable = false, length = 15)
    private String telefone;

    @Column(name = "endereco", nullable = false, length = 100)
    private String endereco;

    @Column(name = "rg", length = 15)
    private String rg;

    @Column(name = "medidas", columnDefinition = "TEXT")
    private String medidas;

    @Column(name = "data_nascimento")
    private LocalDate dataNascimento;


    public Integer getIdCliente() { return idCliente; }
    public void setIdCliente(Integer idCliente) { this.idCliente = idCliente; }
    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }
    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }
    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }
    public String getRg() { return rg; }
    public void setRg(String rg) { this.rg = rg; }
    public String getMedidas() { return medidas; }
    public void setMedidas(String medidas) { this.medidas = medidas; }
    public LocalDate getDataNascimento() { return dataNascimento; }
    public void setDataNascimento(LocalDate dataNascimento) { this.dataNascimento = dataNascimento; }
    @Column(name = "id_usuario", insertable = false, updatable = false)
private Integer idUsuario;

public Integer getIdUsuario() { return idUsuario; }
public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }
}