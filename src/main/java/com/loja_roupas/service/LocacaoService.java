package com.loja_roupas.service;

import com.loja_roupas.dto.LocacaoRequest;
import com.loja_roupas.dto.LocacaoResponse;
import com.loja_roupas.model.*;
import com.loja_roupas.repository.*;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.List;

@Service
public class LocacaoService {

    private final LocacaoRepository locacaoRepository;
    private final ItemLocacaoRepository itemRepository;
    private final ClienteRepository clienteRepository;
    private final UsuarioRepository usuarioRepository;
    private final FuncionarioRepository funcionarioRepository;
    private final ProdutoRepository pecaRepository; // repository da PecaProduto

    public LocacaoService(LocacaoRepository locacaoRepository,
                          ItemLocacaoRepository itemRepository,
                          ClienteRepository clienteRepository,
                          UsuarioRepository usuarioRepository,
                          FuncionarioRepository funcionarioRepository,
                          ProdutoRepository pecaRepository) {
        this.locacaoRepository = locacaoRepository;
        this.itemRepository = itemRepository;
        this.clienteRepository = clienteRepository;
        this.usuarioRepository = usuarioRepository;
        this.funcionarioRepository = funcionarioRepository;
        this.pecaRepository = pecaRepository;
    }

    @Transactional
    public LocacaoResponse criar(LocacaoRequest req) {
        validar(req);

        Cliente cliente = clienteRepository.findById(req.idCliente())
                .orElseThrow(() -> naoEncontrado("Cliente", req.idCliente()));
        Usuario usuario = usuarioRepository.findById(req.idUsuario())
                .orElseThrow(() -> naoEncontrado("Usuário", req.idUsuario()));
        Funcionario funcionario = funcionarioRepository.findById(req.idFuncionario())
                .orElseThrow(() -> naoEncontrado("Funcionário", req.idFuncionario()));

        LocalDate inicio = req.dataEvento();
        LocalDate fim = req.dataDevolucao() != null ? req.dataDevolucao() : req.dataEvento();

        Locacao locacao = new Locacao();
        locacao.setCliente(cliente);
        locacao.setUsuario(usuario);
        locacao.setFuncionario(funcionario);
        locacao.setDataEvento(req.dataEvento());
        locacao.setDataDevolucao(req.dataDevolucao());

        for (Integer idPeca : req.idsPecas()) {
            Produto peca = pecaRepository.findById(idPeca)
                    .orElseThrow(() -> naoEncontrado("Peça", idPeca));

            if (itemRepository.existeConflito(idPeca, inicio, fim)) {
                throw new ResponseStatusException(HttpStatus.CONFLICT,
                        "Peça " + idPeca + " já está locada no período informado");
            }

            ItemLocacao item = new ItemLocacao();
            item.setPeca(peca);
            locacao.adicionarItem(item);
        }

        return toResponse(locacaoRepository.save(locacao));
    }

    @Transactional(readOnly = true)
    public List<LocacaoResponse> listar() {
        return locacaoRepository.findAll().stream().map(this::toResponse).toList();
    }

    @Transactional(readOnly = true)
    public LocacaoResponse buscar(Integer id) {
        return locacaoRepository.findById(id)
                .map(this::toResponse)
                .orElseThrow(() -> naoEncontrado("Locação", id));
    }

    @Transactional
    public void deletar(Integer id) {
        if (!locacaoRepository.existsById(id)) {
            throw naoEncontrado("Locação", id);
        }
        locacaoRepository.deleteById(id);
    }

    private void validar(LocacaoRequest req) {
        if (req.idCliente() == null || req.idUsuario() == null || req.idFuncionario() == null
                || req.dataEvento() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "idCliente, idUsuario, idFuncionario e dataEvento são obrigatórios");
        }
        if (req.idsPecas() == null || req.idsPecas().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "A locação precisa ter ao menos uma peça");
        }
        if (req.idsPecas().stream().distinct().count() != req.idsPecas().size()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Há peças repetidas na locação");
        }
        if (req.dataDevolucao() != null && req.dataDevolucao().isBefore(req.dataEvento())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "A data de devolução não pode ser anterior à data do evento");
        }
    }

    private ResponseStatusException naoEncontrado(String entidade, Integer id) {
        return new ResponseStatusException(HttpStatus.NOT_FOUND, entidade + " não encontrado(a): " + id);
    }

    private LocacaoResponse toResponse(Locacao l) {
        return new LocacaoResponse(
                l.getIdLocacao(),
                l.getCliente().getIdCliente(),
                l.getUsuario().getIdUsuario(),
                l.getFuncionario().getIdFuncionario(),
                l.getDataEvento(),
                l.getDataDevolucao(),
                l.getItens().stream().map(i -> i.getPeca().getIdPeca()).toList()
        );
    }
}