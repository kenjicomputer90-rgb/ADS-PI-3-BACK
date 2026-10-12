package com.loja_roupas.dto;

import java.time.LocalDate;
import java.util.List;

public record LocacaoRequest(
        Integer idCliente,
        Integer idUsuario,
        Integer idFuncionario,
        LocalDate dataEvento,
        LocalDate dataDevolucao,
        List<Integer> idsPecas
) {}