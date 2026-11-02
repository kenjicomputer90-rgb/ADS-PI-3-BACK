package com.loja_roupas.dto;

import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Dados que chegam na API para cadastrar ou atualizar um funcionário.
 * As anotações validam cada campo antes de o pedido chegar no service.
 */
public record FuncionarioRequest(
        @NotNull Integer idUsuario,
        @NotBlank @Size(max = 100) String nome,
        @NotBlank @Size(max = 14) String cpf,
        @Size(max = 20) String rg,
        @Size(max = 20) String telefone,
        @Size(max = 20) String ctps,
        @PositiveOrZero Integer dependente,
        @Size(max = 20) String sexo,
        @PositiveOrZero @Digits(integer = 8, fraction = 2) BigDecimal salario,
        @Past LocalDate dataNascimento,
        @Size(max = 30) String estadoCivil
) {}