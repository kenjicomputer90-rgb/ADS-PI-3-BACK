package com.loja_roupas.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "locacao")
public class Locacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_locacao")
    private Integer idLocacao;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "id_cliente", nullable = false)
    private Cliente cliente;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "id_funcionario", nullable = false)
    private Funcionario funcionario;

    @Column(name = "data_evento", nullable = false)
    private LocalDate dataEvento;

    @Column(name = "data_devolucao")
    private LocalDate dataDevolucao;

    @OneToMany(mappedBy = "locacao", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ItemLocacao> itens = new ArrayList<>();

    public void adicionarItem(ItemLocacao item) {
        item.setLocacao(this);
        itens.add(item);
    }

    public Integer getIdLocacao() { return idLocacao; }
    public void setIdLocacao(Integer idLocacao) { this.idLocacao = idLocacao; }
    public Cliente getCliente() { return cliente; }
    public void setCliente(Cliente cliente) { this.cliente = cliente; }
    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }
    public Funcionario getFuncionario() { return funcionario; }
    public void setFuncionario(Funcionario funcionario) { this.funcionario = funcionario; }
    public LocalDate getDataEvento() { return dataEvento; }
    public void setDataEvento(LocalDate dataEvento) { this.dataEvento = dataEvento; }
    public LocalDate getDataDevolucao() { return dataDevolucao; }
    public void setDataDevolucao(LocalDate dataDevolucao) { this.dataDevolucao = dataDevolucao; }
    public List<ItemLocacao> getItens() { return itens; }
    public void setItens(List<ItemLocacao> itens) { this.itens = itens; }
}