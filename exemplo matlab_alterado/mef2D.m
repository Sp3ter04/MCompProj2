% Programa de elementos finitos para elementos 2D
% Exemplo para o elemento T6 em elasticidade 2D

clear all;
close all;

nnel = 6; % Numero de nos por elemento
ndof = 2; % Numero de graus de liberdade por no (para problemas de elasticidade 2D)
nnode = 65; % Numero de nos
nelem = 26; % Numero de elementos
sdof = ndof * nnode; % Numero total de graus de liberdade na malha

[gcoord, nodes] = extrair_dados(); % Extrair dados de nos e elementos

% Numeracao dos graus de liberdade globais dos nos
gdl = zeros(nnode, ndof);
igdl = 0;
for i = 1:nnode
    for j = 1:ndof
        igdl = igdl + 1;
        gdl(i, j) = igdl;
    end
end

% Propriedades dos elementos
Young = 200e9 * ones(nelem, 1); % Modulo de elasticidade igual para todos os elementos
nu = 0.3 * ones(nelem, 1);
tk = 1e-3 * ones(nelem, 1); % Espessura

% Aplicar carga pontual a todos os nos
face_force = find(gcoord(:, 1) == 0.4); % Identificar nos na face direita

P = zeros(sdof, 1); % Inicializar vetor de forcas globais
P(face_force * 2 - 1) = 1e6; % Aplicar forca no eixo x para os nos da face direita

% Aplicar condicoes de fronteira
nos_x_nulo = find(gcoord(:, 1) == 0); % Nos com x = 0
nos_y_nulo = find(gcoord(:, 2) == 0); % Nos com y = 0

if isempty(nos_x_nulo) || isempty(nos_y_nulo)
    error('Nenhum no encontrado para aplicar condicoes de fronteira.');
end

% Graus de liberdade restritos
gdl_nulo_x = nos_x_nulo * 2 - 1;
gdl_nulo_y = nos_y_nulo * 2;
bcdof = [gdl_nulo_x; gdl_nulo_y]';
bcval = zeros(size(bcdof));

% Inicializacao das matrizes e vetores
ff = zeros(sdof, 1); % Vetor de forcas global
kk = zeros(sdof, sdof); % Matriz de rigidez global
index = zeros(nnel * ndof, 1); % Vetor de indexacao dos graus de liberdade do elemento

% Calculo das matrizes de rigidez e montagem
for iel = 1:nelem
    n = nodes(iel, 1:nnel); % Numeracao global de nos do elemento
    xe = gcoord(n, 1); % Coordenadas x dos nos do elemento
    ye = gcoord(n, 2); % Coordenadas y dos nos do elemento

    k = stif_T6(Young(iel), nu(iel), tk(iel), xe, ye); % Matriz de rigidez do elemento
    f = zeros(nnel * 2, 1); % Forcas nodais equivalentes

    index = eldof(iel, nnel, nodes, gdl);
    [kk, ff] = assemb(kk, ff, k, f, index);
end



% Imposicao de condicoes de fronteira
[kk, ff] = cf(kk, ff, bcdof, bcval);

% Adicao de cargas pontuais
ff = ff + P;

% Solucao do sistema de equacoes
u = kk \ ff;

% Representacao da deformada
UX = u(1:2:2 * nnode);
UY = u(2:2:2 * nnode);
scaleFactor = .1;
figure;
drawingField(gcoord + scaleFactor * [UX, UY], nodes, 'T6', UX);
hold on;
drawingMesh(gcoord + scaleFactor * [UX, UY], nodes, 'T6', '-');
drawingMesh(gcoord, nodes, 'T6', '--');
colorbar;
title('Displacement field u_x (on deformed shape)');
