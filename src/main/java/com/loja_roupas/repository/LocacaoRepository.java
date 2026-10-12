package com.loja_roupas.repository;

import com.loja_roupas.model.Locacao;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LocacaoRepository extends JpaRepository<Locacao, Integer> {
}