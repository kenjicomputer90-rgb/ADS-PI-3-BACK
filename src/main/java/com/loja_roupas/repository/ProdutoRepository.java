package com.loja_roupas.repository;

import com.loja_roupas.model.Produto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProdutoRepository extends JpaRepository<Produto, Integer> {

    Optional<Produto> findByCodigoUnico(String codigoUnico);

    boolean existsByCodigoUnico(String codigoUnico);

    // Filtros opcionais: parâmetro null = não filtra por ele
    @Query("""
            SELECT p FROM Produto p
            WHERE (:descricao IS NULL OR LOWER(p.descricao) LIKE LOWER(CONCAT('%', :descricao, '%')))
              AND (:tamanho IS NULL OR UPPER(p.tamanho) = UPPER(:tamanho))
              AND (:cor IS NULL OR LOWER(p.cor) = LOWER(:cor))
            ORDER BY p.descricao
            """)
    List<Produto> filtrar(@Param("descricao") String descricao,
                          @Param("tamanho") String tamanho,
                          @Param("cor") String cor);
}