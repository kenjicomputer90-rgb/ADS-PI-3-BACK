package com.loja_roupas.repository;

import com.loja_roupas.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ClienteRepository extends JpaRepository<Cliente, Integer> {

    Optional<Cliente> findByCpf(String cpf);

    boolean existsByCpf(String cpf);

    Optional<Cliente> findByIdUsuario(Integer idUsuario);

    List<Cliente> findByNomeContainingIgnoreCaseOrderByNome(String nome);
}