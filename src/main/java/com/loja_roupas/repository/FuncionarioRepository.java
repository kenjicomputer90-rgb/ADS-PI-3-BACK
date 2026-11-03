package com.loja_roupas.repository;

import com.loja_roupas.model.Funcionario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * Acesso à tabela funcionario.
 * O JpaRepository já traz save, findById, findAll, deleteById etc.
 * Os métodos abaixo o Spring Data cria sozinho, a partir do nome.
 */
public interface FuncionarioRepository extends JpaRepository<Funcionario, Integer> {

    /** Procura um funcionário pelo CPF exato. */
    Optional<Funcionario> findByCpf(String cpf);

    /** Diz se já existe funcionário com esse CPF (usado para barrar duplicados). */
    boolean existsByCpf(String cpf);

    /** Procura o funcionário vinculado a um usuário (cada usuário só pode ter um). */
    Optional<Funcionario> findByUsuario_IdUsuario(Integer idUsuario);

    /** Busca por parte do nome, sem diferenciar maiúsculas de minúsculas, em ordem alfabética. */
    List<Funcionario> findByNomeContainingIgnoreCaseOrderByNome(String nome);
}