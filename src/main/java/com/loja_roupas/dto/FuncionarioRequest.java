package com.loja_roupas.dto;

import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Dados que chegam na API para cadastrar ou atualizar um funcionário.
 * As anotações validam cada campo antes de o pedido chegar no service,
 * e a mensagem de cada uma é o texto que volta no erro 400.
 */
public record FuncionarioRequest(
        @NotNull(message = "O usuário é obrigatório")
        Integer idUsuario,

        @NotBlank(message = "O nome é obrigatório")
        @Size(max = 100, message = "O nome pode ter no máximo 100 caracteres")
        String nome,

        @NotBlank(message = "O CPF é obrigatório")
        @Pattern(regexp = "\\d{3}\\.\\d{3}\\.\\d{3}-\\d{2}",
                 message = "O CPF deve estar no formato 000.000.000-00")
        String cpf,

        @Size(max = 20, message = "O RG pode ter no máximo 20 caracteres")
        String rg,

        @Size(max = 20, message = "O telefone pode ter no máximo 20 caracteres")
        String telefone,

        @Size(max = 20, message = "A CTPS pode ter no máximo 20 caracteres")
        String ctps,

        @PositiveOrZero(message = "Dependentes não pode ser negativo")
        Integer dependente,

        @Size(max = 20, message = "O sexo pode ter no máximo 20 caracteres")
        String sexo,

        @PositiveOrZero(message = "O salário não pode ser negativo")
        @Digits(integer = 8, fraction = 2, message = "O salário deve ter até 8 dígitos e 2 casas decimais")
        BigDecimal salario,

        @Past(message = "A data de nascimento deve estar no passado")
        LocalDate dataNascimento,

        @Size(max = 30, message = "O estado civil pode ter no máximo 30 caracteres")
        String estadoCivil
) {}