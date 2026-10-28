% =========================================================================
%  program1_SDP.m  -  STOCHASTYCZNE PROGRAMOWANIE DYNAMICZNE
%  Liczy optymalna polityke wydawania pieniedzy u*(k,x).
%
%  Rownanie Bellmana (MAKSYMALIZACJA):
%    V_N(x) = beta^N * sqrt(x)                         (ostatni rok: wydaj wszystko)
%    V_k(x) = max_{0<=u<=x} sum_l p_l * [ beta^k*sqrt(u) + V_{k+1}(f(x,u,w_l)) ]
%    f(x,u,w) = max(0, (1+alpha)*(x - u - w))
%
%  
% =========================================================================
clear; clc;
parametry;

V = zeros(N+1, nx);   % V(k+1,i) - najlepsze oczekiwane zadowolenie od roku k, gdy x = X(i)
U = zeros(N+1, nx);   % U(k+1,i) - optymalne wydatki w roku k, gdy x = X(i)

% --- Ostatni rok k = N: wydaje wszystko ----------------------------------
V(N+1,:) = beta^N * sqrt(X);
U(N+1,:) = X;

tic   
% --- Petla 1: CZAS (od konca, cofajac sie) --------------------------------
for k = N-1:-1:0
    % --- Petla 2: STAN (ile ma na koncie) ---------------------------------
    for i = 1:nx
        Vbest = -Inf;
        % --- Petla 3: STEROWANIE (ile wydac), tylko u <= x ----------------
        for j = 1:i
            u = X(j);
            E = 0;                                  % wartosc oczekiwana
            % --- Petla 4: ZAKLOCENIE (jaka awaria) -------------------------
            for l = 1:length(w)
                x1 = max(0, (1+alpha)*(X(i) - u - w(l)));  % nastepny stan
                i1 = min(nx, round(x1/dx) + 1);            % najblizszy punkt siatki
                E  = E + p(l) * (beta^k*sqrt(u) + V(k+2, i1));
            end
            % MAKSYMALIZACJA -> warunek ">" 
            if E > Vbest
                Vbest = E;
                ubest = u;
            end
        end
        V(k+1,i) = Vbest;
        U(k+1,i) = ubest;
    end
end
toc

% --- Wynik dla naszego spadku ---------------------------------------------
i0 = round(x0/dx) + 1;
fprintf('Oczekiwane laczne zadowolenie E[J] = V_0(x0) = %.4f\n', V(1,i0));
fprintf('Optymalne wydatki w roku 0 przy x0 = %d: u* = %d zl\n', x0, U(1,i0));

save wyniki_P1.mat V U      % zapis dla programu 2 (i dla kolegow: P3, P7)

% --- Wykres 1: polityka u*(k,x) dla kilku lat -----------------------------
figure; hold on; grid on;
for k = [0 10 20 25 29]
    plot(X, U(k+1,:), 'LineWidth', 1.5, 'DisplayName', sprintf('k = %d', k));
end
plot(X, X, 'k--', 'DisplayName', 'u = x (wszystko)');
xlabel('stan konta x [zl]'); ylabel('optymalne wydatki u^* [zl]');
title('Optymalna polityka u^*(k,x)'); legend('Location', 'northwest');

% --- Wykres 2: funkcja wartosci V_0(x) ------------------------------------
figure; plot(X, V(1,:), 'LineWidth', 1.5); grid on;
xlabel('stan konta x [zl]'); ylabel('V_0(x)');
title('Funkcja wartosci na poczatku (k = 0)');
