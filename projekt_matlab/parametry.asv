% =========================================================================
%  parametry.m  -  WSPOLNE LICZBY DLA CALEGO PROJEKTU
%  Wszystkie programy zaczynaja sie od wywolania:  parametry
%  Wszystkie kwoty w ZLOTYCH.
% =========================================================================

x0 = 700000;     % spadek (stan konta na poczatku) [zl]
N  = 30;         % horyzont: zyje jeszcze 30 lat, k = 0,1,...,N

% --- Oprocentowanie ------------------------------------------------------
r_nom = 0.07;                    % srednia stopa zwrotu konta oszczednosciowego
r_inf = 0.03;                    % inflacja
alpha = (1+r_nom)/(1+r_inf) - 1; % REALNA stopa zwrotu = ok. 0.0388
% (w przyblizeniu 0.07 - 0.03 = 0.04; wzor wyzej jest dokladny)

beta = 0.96;     % wspolczynnik dyskonta (niecierpliwosc), beta < 1


% --- Zaklocenia w: nieprzewidziane wydatki w ciagu roku [zl] -------------
%       0 zl  - spokojny rok, nic sie nie zepsulo
%   1 000 zl  - drobna naprawa, weterynarz, mandat
%   5 000 zl  - nowa pralka/lodowka, leczenie u dentysty
%  10 000 zl  - powazna naprawa samochodu
%  35 000 zl  - powazna choroba, remont dachu, zalanie mieszkania
w = [0     1000  5000  10000  35000];
p = [0.25  0.30  0.25  0.15   0.05 ];   % prawdopodobienstwa (suma = 1)
% Wartosc oczekiwana: E[w] = sum(p.*w) = 4 800 zl rocznie

% --- Dyskretyzacja --------------------------------------------------------
dx   = 1000;          % krok siatki [zl] - nie wiekszy niz najmniejsza awaria
xmax = 1000000;       % gorna granica stanu; przy optymalnej polityce konto
                      % i tak nie rosnie ponad x0 (sprawdzone: wieksze xmax
                      % daje identyczny wynik, a liczy sie dluzej)
X    = 0:dx:xmax;     % dyskretne poziomy stanu: 0, 1000, 2000, ..., 1 000 000
nx   = length(X);     % liczba poziomow stanu (1001)
% Sterowania u maja te same poziomy co stan, z ograniczeniem 0 <= u <= x.

% --- Zalozenia (opisac w sprawozdaniu) -----------------------------------
% 1) Kolejnosc w roku: najpierw wydaje u, potem przychodzi awaria w.
% 2) Jesli awaria jest wieksza niz to, co zostalo, konto spada do 0
%    (x nie moze byc ujemne):  x_{k+1} = max(0, (1+alpha)(x_k - u_k - w_k)).
% 3) W ostatnim roku (k = N) wydaje wszystko: u_N = x_N.
% 4) Nastepny stan zaokraglamy do najblizszego punktu siatki X.
