package com.loja_roupas.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

public record ProdutoRequest(
        @NotBlank @Size(max = 40) String codigoUnico,
        @NotBlank @Size(max = 100) String descricao,
        @NotBlank @Size(max = 10) String tamanho,
        @NotBlank @Size(max = 30) String cor,
        @Size(max = 40) String material,
        @NotNull @DecimalMin("0.00") @Digits(integer = 8, fraction = 2) BigDecimal preco
) {}