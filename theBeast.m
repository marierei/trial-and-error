global N;
% Definerer noder for trussen
N = [46	13  1
    46	13 35
    46	35  1
    46	46 34
    
    46	46 67
    57	68 67
    68	13  1
    68	13 35
    
    68	35  1
    68	46 34
    68	46 67]; % Klumper sammen i 4 og 4 rader for å lettere kunne telle
N = N / 100;   % minker størrelser til under en meter

global E;
% Kobler sammen noder med et edge-array
E = [8	7
    2	1
    2	8
    11	8
    5	2
    6	5
    11	6
    4	3
    2	4
    6	4
    10	9
    6	10
    10	4
    8	10
    5	11
    11	10
    5	4
    3	2
    8	9
    1	8
    8  5];


% Spesifiserer arealtverrsnitt og da stivhet
radius = 0.003;       % Meter
E(:,3) = pi*radius^2;  % Arealer

global extC;
% Spesifiserer hvilke noder som er låst og i hvilke retninger
% 1 er fri og 0 er låst
extC = [0 0 0
    1 1 1
    0 0 0
    1 1 1
    
    1 1 1
    1 1 1
    0 0 0
    1 1 1
    
    0 0 0
    1 1 1
    1 1 1];

global extF;
% Spesifiserer kreftene påført hver node og retning
% Her kun én node som blir påført en kraft, z-retningen
extF = [0 0 0
    0 0 0
    0 0 0
    0 0 0
    
    0 0 0
    0 0 12
    0 0 0
    0 0 0
    
    0 0 0
    0 0 0
    0 0 0];


% Kjører FEM-simulator
% Får stress edge array og displacement node array som brukes til videre
% plotting
[sE, dN] = FEM_truss(N,E, extF,extC);


% Sammenligner dN med N for å få forflytning
% Skalerer opp med 100 for å faktisk se forflytning
figure(1);clf;plotMesh(N,E); % Opprinnelig mesh
visuellScale = 100; % Vi vil visuelt skalere opp forflytningene for de er små
hold on;plotMesh(N-visuellScale*dN,E, 'col',[1 0 0]); % Mesh med nodeforflytninger i rød farge
hold on;plotMeshCext(N,extC,100);
hold on;plotMeshFext(N-visuellScale*dN,extF, 0.01);
view([-120 10]);

x_plot = 1;

opprinneligLengde = maxEdgeLng(E,N)

% Finner nedbøyningen av node 6 i z-retningen
global nedBoy;
nedBoy = dN(6,3)


%global maxE = maxEdgeLng(E,N);
global maxE;
maxE = maxEdgeLng(E,N);
count1 = 0;
count2 = 0;

% Finner hvilke noder som er ulåste
for i=1 : size(N,1)
    if extC(i,:) == [1 1 1]
        if extF(i,:) == [0 0 0]
            % Plassering i array
            count1 = count1 + 1;
            % Setter inn plassering av noder som skal flyttes i eget array
            noderFlytt(count1,:) = N(i,:);
        end
    end
    if not(extC(i,:) == [1 1 1])
        count2 = count2 + 1;
        ikkeFlytt(count2,:) = N(i,:);
    end
end


%nedover = objFun1(noderFlytt)






nedover = @objFun1

ned = N(6,:)
x0 = [0 0 0];
lb = 0.1 * [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
ub = 0.1 * [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%rng = default
%T = simulannealbnd(noderFlytt, maxE);
[x,fval] = simulannealbnd(nedover, noderFlytt, lb, ub)

%x = ga(nedover, 18)

x;

T = zeros(size(N));


T(1,:) = N(1,:);
T(2,:) = N(2,:) - x(1,:);
T(3,:) = N(3,:);
T(4,:) = N(4,:) - x(2,:);
T(5,:) = N(5,:) - x(3,:);
T(6,:) = N(6,:);
T(7,:) = N(7,:);
T(8,:) = N(8,:) - x(4,:);
T(9,:) = N(9,:);
T(10,:) = N(10,:) - x(5,:);
T(11,:) = N(11,:) - x(6,:);

[sE, dN] = FEM_truss(T,E, extF,extC);
nyNed = dN(6,3)

% Forflytning for å få ny mest
figure(2);clf;plotMesh(N,E); % Opprinnelig mesh
%visuellScale = 100; % Vi vil visuelt skalere opp forflytningene for de er små
hold on;plotMesh(T,E, 'col',[1 0 0]); % Mesh med nodeforflytninger i rød farge
hold on;plotMeshCext(N,extC,100);
hold on;plotMeshFext(T,extF, 0.01);
[V,F] = mesh2poly2(T,E,0.015,20); % radius, antall plygonsider
figure(2);clf;plotPoly(F,V,'edgeOff');
view([-120 10]);sun1;
view([-120 10]);

% Lager gif
saveFigToTurntableAnimGif('truss.gif','ant',50);

%nedover = objFun1(noderFlytt)
 