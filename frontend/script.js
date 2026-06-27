// =============================================================================
// METADADOS DAS CONSULTAS
// Cada objeto descreve uma consulta: número, título, descrição,
// e se tem parâmetro (para consultas 2 e 6).
// =============================================================================
const CONSULTAS = [
  {
    numero: 1,
    titulo: "Perfis por Plano",
    descricao: "Quantidade de perfis cadastrados em cada plano de assinatura.",
    parametro: null, // sem parâmetro: fetch automático ao abrir
  },
  {
    numero: 2,
    titulo: "Títulos Mais Avaliados",
    descricao: "Títulos adultos com mais de N avaliações.",
    parametro: {
      nome: "min_avaliacoes", // nome do query param na URL
      label: "Mínimo de avaliações:", // texto do label no modal
    },
  },
  {
    numero: 3,
    titulo: "Títulos por Gênero",
    descricao: "Quantidade de títulos agrupados por gênero.",
    parametro: null,
  },
  {
    numero: 4,
    titulo: "Pessoas em Títulos Bem Avaliados",
    descricao:
      "Atores e diretores que participaram de títulos com avaliação acima da média.",
    parametro: null,
  },
  {
    numero: 5,
    titulo: "Séries com Episódios Longos",
    descricao: "Séries que possuem episódios acima da duração média.",
    parametro: null,
  },
  {
    numero: 6,
    titulo: "Perfis que Assistiram Tudo",
    descricao: "Perfis que assistiram todos os episódios de um título.",
    parametro: {
      nome: "id_titulo", // nome do query param na URL
      label: "ID do título:", // texto do label no modal
    },
  },
  {
    numero: 7,
    titulo: "Títulos Fora das Listas",
    descricao: "Títulos que nenhum perfil adicionou à sua lista.",
    parametro: null,
  },
  {
    numero: 8,
    titulo: "Avaliações Nota 5 — Filmes Adultos",
    descricao: "Avaliações com nota máxima em filmes do catálogo adulto.",
    parametro: null,
  },
  {
    numero: 9,
    titulo: "Média por Gênero — Adulto",
    descricao: "Média de avaliações por gênero no catálogo adulto.",
    parametro: null,
  },
  {
    numero: 10,
    titulo: "Equipe de Títulos Infantis",
    descricao:
      "Perfis infantis, os títulos assistidos e as pessoas envolvidas.",
    parametro: null,
  },
];

// =============================================================================
// VARIÁVEL DE ESTADO
// Guarda qual consulta está aberta no momento para saber qual
// URL montar quando o usuário clicar em "Buscar" nas consultas parametrizadas.
// =============================================================================
let consultaAtiva = null;

// =============================================================================
// RENDERIZAR OS CARDS NA PÁGINA
// Roda uma vez quando a página carrega.
// Para cada consulta em CONSULTAS, cria um elemento <div> com as classes
// do Tailwind e um onclick que chama abrirModal().
// =============================================================================
function renderizarCards() {
  const container = document.getElementById("cards");

  CONSULTAS.forEach((consulta) => {
    const card = document.createElement("div");

    // Classes Tailwind para estilo do card
    card.className = [
      "bg-zinc-900 border border-zinc-700 rounded-xl p-5",
      "cursor-pointer hover:border-red-600 hover:bg-zinc-800",
      "transition-all duration-200",
    ].join(" ");

    // Conteúdo interno do card
    card.innerHTML = `
      <span class="text-red-500 text-xs font-bold uppercase tracking-widest">Consulta ${consulta.numero}</span>
      <h3 class="text-white font-semibold mt-1 mb-2">${consulta.titulo}</h3>
      <p class="text-zinc-400 text-sm">${consulta.descricao}</p>
    `;

    // Ao clicar no card, abre o modal passando o número da consulta
    card.addEventListener("click", () => abrirModal(consulta.numero));

    container.appendChild(card);
  });
}

// =============================================================================
// ABRIR MODAL
// Recebe o número da consulta, configura o modal e o exibe.
// Se a consulta não tem parâmetro, já dispara o fetch automaticamente.
// Se tem parâmetro, exibe o campo de input e aguarda o usuário clicar em Buscar.
// =============================================================================
function abrirModal(numero) {
  // Encontra os metadados da consulta pelo número
  const consulta = CONSULTAS.find((c) => c.numero === numero);
  consultaAtiva = consulta; // salva no estado global

  // Preenche o título do modal
  document.getElementById("modal-titulo").textContent =
    `Consulta ${consulta.numero} — ${consulta.titulo}`;

  // Limpa o resultado anterior
  document.getElementById("modal-resultado").innerHTML = "";

  const areaInput = document.getElementById("modal-input");

  if (consulta.parametro) {
    // Consulta parametrizada: mostra o campo de input com o label correto
    document.getElementById("modal-label").textContent =
      consulta.parametro.label;
    document.getElementById("modal-param").value = ""; // limpa valor anterior
    areaInput.classList.remove("hidden");
  } else {
    // Consulta simples: esconde o input e busca direto
    areaInput.classList.add("hidden");
    buscarDados(); // fetch imediato
  }

  // Exibe o modal removendo a classe "hidden"
  document.getElementById("modal").classList.remove("hidden");
}

// =============================================================================
// FECHAR MODAL
// Chamado pelo botão X no HTML.
// Adiciona "hidden" de volta para esconder o modal.
// =============================================================================
function fecharModal() {
  document.getElementById("modal").classList.add("hidden");
  consultaAtiva = null;
}

// =============================================================================
// BUSCAR COM PARÂMETRO
// Chamado pelo botão "Buscar" nas consultas 2 e 6.
// Lê o valor do input e passa para buscarDados().
// =============================================================================
function buscarComParametro() {
  const valor = document.getElementById("modal-param").value.trim();

  if (!valor) {
    alert("Digite um valor antes de buscar.");
    return;
  }

  buscarDados(valor);
}

// =============================================================================
// BUSCAR DADOS NO BACKEND
// Monta a URL com ou sem parâmetro, faz o fetch e chama renderizarTabela().
// =============================================================================
async function buscarDados(valorParametro = null) {
  const resultado = document.getElementById("modal-resultado");
  resultado.innerHTML = `<p class="text-zinc-400 text-sm">Carregando...</p>`;

  try {
    // Monta a URL base
    let url = `http://localhost:8080/consultas/${consultaAtiva.numero}`;

    // Se tem parâmetro, adiciona como query string na URL
    // Ex: /consultas/2?min_avaliacoes=5
    if (consultaAtiva.parametro && valorParametro !== null) {
      url += `?${consultaAtiva.parametro.nome}=${valorParametro}`;
    }

    // fetch() faz a requisição GET para o backend Go
    const resposta = await fetch(url);

    if (!resposta.ok) {
      throw new Error(`Erro HTTP: ${resposta.status}`);
    }

    // .json() converte o corpo da resposta de texto JSON para array JavaScript
    const dados = await resposta.json();

    renderizarTabela(dados, resultado);
  } catch (erro) {
    resultado.innerHTML = `<p class="text-red-400 text-sm">Erro ao buscar dados: ${erro.message}</p>`;
  }
}

// =============================================================================
// RENDERIZAR TABELA
// Recebe o array de objetos retornado pelo backend e constrói uma tabela HTML.
// As colunas são derivadas automaticamente das chaves do primeiro objeto.
// =============================================================================
function renderizarTabela(dados, container) {
  if (!dados || dados.length === 0) {
    container.innerHTML = `<p class="text-zinc-400 text-sm">Nenhum resultado encontrado.</p>`;
    return;
  }

  // Pega os nomes das colunas a partir das chaves do primeiro objeto
  // Ex: { plano: "Premium", qnt_perfis: 12 } → ["plano", "qnt_perfis"]
  const colunas = Object.keys(dados[0]);

  // Constrói o cabeçalho (<thead>) com uma <th> para cada coluna
  const thead = colunas
    .map(
      (col) =>
        `<th class="px-4 py-2 text-left text-xs font-semibold text-zinc-400 uppercase tracking-wider whitespace-nowrap">${col}</th>`,
    )
    .join("");

  // Constrói as linhas (<tbody>) com uma <td> para cada valor
  const tbody = dados
    .map((linha) => {
      const celulas = colunas
        .map(
          (col) =>
            `<td class="px-4 py-2 text-sm text-zinc-200 whitespace-nowrap">${linha[col]}</td>`,
        )
        .join("");
      return `<tr class="border-t border-zinc-800 hover:bg-zinc-800/50">${celulas}</tr>`;
    })
    .join("");

  // Injeta a tabela completa no container do modal
  container.innerHTML = `
    <p class="text-xs text-zinc-500 mb-3">${dados.length} resultado(s)</p>
    <div class="overflow-x-auto">
      <table class="w-full text-left">
        <thead><tr>${thead}</tr></thead>
        <tbody>${tbody}</tbody>
      </table>
    </div>
  `;
}

// =============================================================================
// FECHAR MODAL AO CLICAR FORA DA CAIXA
// Se o clique foi no fundo escuro (o próprio #modal, não seus filhos),
// fecha o modal.
// =============================================================================
document.getElementById("modal").addEventListener("click", (evento) => {
  if (evento.target === document.getElementById("modal")) {
    fecharModal();
  }
});

// =============================================================================
// INICIALIZAÇÃO
// Chama renderizarCards() assim que o script carrega para popular a página.
// =============================================================================
renderizarCards();
