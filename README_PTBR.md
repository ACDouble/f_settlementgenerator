# A ideia geral
Uma ferramenta para Narradores de jogos medievais e de fantasia para gerarem locais de interesse habitados

# A explicação longa
Um gerador simples de assentamentos com várias informações. Basicamente, você vai gerar algo com informação de:
* Clima (ártico, temperado ou tropical)
* Terreno (plano, serrano ou montanhoso)
* Chuva (frequente, sasonal ou rara)
* Se é um entreposto comercial (um pequeno local entre cidades, onde caravanas comerciais normalmente passariam a noite. Esta é a única flag que define um limite baixo para a população)
* Se é um centro comercial (uma espécie de cruzamento entre várias rotas mercantes, dando acesso a vários recursos de fora)
* Se tem acesso ao mar, água doce e solo fértil
* Recursos ao qual tem acesso (similar aos recursos nos jogos de Civilization, como Ferro, Cobre, Chá, etc)
* Há quanto tempo o local existe (afeta diretamente a população)
* População (calculada a partir de um numero aleatório, multiplicado por alguns fatores, como recursos, terreno e clima)
* Quantas estalagens, capelas, templos e mercados o local tem
* Quais serviços podem ser encontrados lá (inclui, mas não se limita a: madeireiros, ferreiros, escribas, sacerdotes, alfaiates, etc)

É gerado em forma de texto fácil de ler, mas sem contexto. Cabe a você definir isto, caso precise.


## O que eu faço com essa informação?
Isso é com você! Fiz essa ferramenta para facilitar o trabalho de Narradores, gerando detalhes sobre vilas e pequenas cidades. Vendo esses dados, fica mais fácil entender porque a população raramente passa de 1000, mas quando passa, normalmente vai bem alto: levar coisas do ponto A ao B quando carroças são tecnologia de ponta quer dizer há poucas (comparados a hoje) mercadorias em trânsito e elas demoram pra chegar.

Combine esse volume baixo com falta de maquinário e fertilizantes artificiais para ajudar com agricultura e faz mais sentido porque tantos lugares não tinham condições de ter populações grandes. Não tinha como alimentar tanta gente! Locais costeiros não só têm acesso a recursos marinhos, como pode ter volume de comércio muito maior.

Então, digamos que você gerou algo com baixa população, apesar de existir há 80 anos, ter água doce e solo fértil. O que aconteceu? Como você interpreta isso? Talvez o local foi saqueado recentemente, ou talvez está lidando com uma praga!

Talvez você gerou um entreposto que tem tudo para se tornar uma grande metrópole, mas ainda é apenas um pequeno entreposto. Talvez o local seja muito perigoso, com muitos bandidos em volta. Quem sabe um grupo não possa se livrar deles?

## Por que [Nim?](https://nim-lang.org/)
É uma linguagem que acho interessante, mesmo que eu não faça coisas com ela com a frequencia que deveria. Pense nela como Python Avançado, pois a sintaxe é um tanto parecida, mas muito mais rápida para a computação. Além disso, compila para várias arquiteturas e sistemas operacionais

### Mas este projeto não é pequeno demais pra se importar com velocidade?
Sem dúvida! Mas, se eu só for me importar com velocidade quando eu decidir que de fato seja necessária, eu provavelmente nunca farei nada com Nim

## Por que não uma página web, javascript?
O engraçado é que Nim compila para JS! O problema é que a biblioteca de interface que escolhi, Nimx, tem [um problema](https://github.com/yglukhov/nimx/issues/520) em aberto (19-junho-2023) onde compilar para JS falha.

# Compile você mesmo
* Baixe e instale [Nim](https://nim-lang.org/install.html)
* Rode o gerenciador de pacotes Nimble para instalar [Nimx](https://github.com/yglukhov/nimx). O comando deve ser `nimble install nimx` em qualquer sistema
* Rode o comando `nim c --d:release --threads:on settlegen.nim`
  * Se você adicionar `--r` como opção, o programa irá rodar assim que terminar a compilação
* Execute o programa compilado

No Windows 10, o arquivo .exe deve ter cerca de 1.8MB. Você pode precisar do SDL2.dll na mesma pasta para que funcione, por isso disponibilizei uma cópia do dll neste repositório.

**NÃO FOI TESTADO EM LINUX OU MACOS!**

## Coisas a fazer
* Chance de rolar população negativa para climas temperados e tropicais, para gerar assentamentos abandonados
* Carregar textos a partir de um arquivo .txt, para facilitar traduções
* Dar nomes para as estalagens
* Carregar lista de recursos, serviços e pesos a partir de arquivos .txt, novamente para facilitar tradução
* Dar uma barra de rolagem para o TextField 

