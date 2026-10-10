package com.loja_roupas.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

public record ClienteRequest(
        @NotBlank @Size(max = 60) String nome,
        @NotBlank @Size(max = 14) String cpf,
        @NotBlank @Size(max = 15) String telefone,
        @NotBlank @Size(max = 100) String endereco,
        @Size(max = 15) String rg,
        String medidas,
        LocalDate dataNascimento,
        Integer idUsuario
) {}