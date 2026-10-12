package com.loja_roupas.repository;

import com.loja_roupas.model.ItemLocacao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;

public interface ItemLocacaoRepository extends JpaRepository<ItemLocacao, Integer> {

    // Verdadeiro se a peça já está em outra locação cujo período cruza com [inicio, fim]
    @Query("""
            select count(i) > 0 from ItemLocacao i
            where i.peca.idPeca = :idPeca
              and i.locacao.dataEvento <= :fim
              and coalesce(i.locacao.dataDevolucao, i.locacao.dataEvento) >= :inicio
            """)
    boolean existeConflito(@Param("idPeca") Integer idPeca,
                           @Param("inicio") LocalDate inicio,
                           @Param("fim") LocalDate fim);
}