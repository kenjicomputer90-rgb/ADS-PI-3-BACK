package com.loja_roupas.dto;

import com.loja_roupas.model.Funcionario;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Dados de um funcionário que a API devolve nas respostas.
 * Do usuário vinculado, só sai o id (a senha nunca aparece aqui).
 */
public record FuncionarioResponse(
        Integer idFuncionario,
        Integer idUsuario,
        String nome,
        String cpf,
        String rg,
        String telefone,
        String ctps,
        Integer dependente,
        String sexo,
        BigDecimal salario,
        LocalDate dataNascimento,
        String estadoCivil
) {

    /**
     * Converte a entidade {@link Funcionario}, que representa a tabela,
     * no formato de resposta da API.
     *
     * @param f funcionário vindo do banco
     * @return os dados prontos para virar JSON
     */
    public static FuncionarioResponse de(Funcionario f) {
        return new FuncionarioResponse(
                f.getIdFuncionario(),
                f.getUsuario().getIdUsuario(),
                f.getNome(),
                f.getCpf(),
                f.getRg(),
                f.getTelefone(),
                f.getCtps(),
                f.getDependente(),
                f.getSexo(),
                f.getSalario(),
                f.getDataNascimento(),
                f.getEstadoCivil()
        );
    }
}