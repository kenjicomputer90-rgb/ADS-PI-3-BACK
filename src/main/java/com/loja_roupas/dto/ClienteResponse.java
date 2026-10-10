package com.loja_roupas.dto;

import com.loja_roupas.model.Cliente;

import java.time.LocalDate;

public record ClienteResponse(
        Integer idCliente,
        String nome,
        String cpf,
        String telefone,
        String endereco,
        String rg,
        String medidas,
        LocalDate dataNascimento,
        Integer idUsuario
) {
    public static ClienteResponse de(Cliente c) {
        return new ClienteResponse(
                c.getIdCliente(),
                c.getNome(),
                c.getCpf(),
                c.getTelefone(),
                c.getEndereco(),
                c.getRg(),
                c.getMedidas(),
                c.getDataNascimento(),
                c.getIdUsuario()
        );
    }
}