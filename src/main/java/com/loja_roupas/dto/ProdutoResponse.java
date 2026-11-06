package com.loja_roupas.dto;

import com.loja_roupas.model.Produto;

import java.math.BigDecimal;

public record ProdutoResponse(
        Integer idPeca,
        String codigoUnico,
        String descricao,
        String tamanho,
        String cor,
        String material,
        BigDecimal preco
) {
    public static ProdutoResponse de(Produto p) {
        return new ProdutoResponse(
                p.getIdPeca(),
                p.getCodigoUnico(),
                p.getDescricao(),
                p.getTamanho(),
                p.getCor(),
                p.getMaterial(),
                p.getPreco()
        );
    }
}