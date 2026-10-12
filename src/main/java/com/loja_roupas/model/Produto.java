package com.loja_roupas.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "peca_produto")
public class Produto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_peca")
    private Integer idPeca;

    @Column(name = "codigo_unico", nullable = false, unique = true, length = 40)
    private String codigoUnico;

    @Column(name = "descricao", nullable = false, length = 100)
    private String descricao;

    @Column(name = "tamanho", nullable = false, length = 10)
    private String tamanho;

    @Column(name = "cor", nullable = false, length = 30)
    private String cor;

    @Column(name = "material", length = 40)
    private String material;

    @Column(name = "preco", nullable = false, precision = 10, scale = 2)
    private BigDecimal preco;

    public Produto() {
    }

    public Integer getIdPeca() { return idPeca; }
    public void setIdPeca(Integer idPeca) { this.idPeca = idPeca; }

    public String getCodigoUnico() { return codigoUnico; }
    public void setCodigoUnico(String codigoUnico) { this.codigoUnico = codigoUnico; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public String getTamanho() { return tamanho; }
    public void setTamanho(String tamanho) { this.tamanho = tamanho; }

    public String getCor() { return cor; }
    public void setCor(String cor) { this.cor = cor; }

    public String getMaterial() { return material; }
    public void setMaterial(String material) { this.material = material; }

    public BigDecimal getPreco() { return preco; }
    public void setPreco(BigDecimal preco) { this.preco = preco; }
}