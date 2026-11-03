package com.loja_roupas.model;

import jakarta.persistence.*;

import java.math.BigDecimal; // acrescentada para LocacaoService

@Entity
@Table(name = "item_locacao")
public class ItemLocacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_item")
    private Integer idItem;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "id_locacao", nullable = false)
    private Locacao locacao;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "id_peca", nullable = false)
    private Produto peca;
    
    @Column(name = "preco_aluguel")  // acrescentada para LocacaoService
    private BigDecimal precoAluguel; // acrescente para LocacaoService

    public Integer getIdItem() { return idItem; }
    public void setIdItem(Integer idItem) { this.idItem = idItem; }
    public Locacao getLocacao() { return locacao; }
    public void setLocacao(Locacao locacao) { this.locacao = locacao; }
    public Produto getPeca() { return peca; }
    public void setPeca(Produto peca) { this.peca = peca; }
    public BigDecimal getPrecoAluguel() { return precoAluguel; }
    public void setPrecoAluguel(BigDecimal precoAluguel) { this.precoAluguel = precoAluguel; }    
    }