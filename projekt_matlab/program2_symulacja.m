% =========================================================================
%  program2_symulacja.m  -  SPRAWDZENIE POLITYKI Z PROGRAMU 1
%  M razy "przezywamy" zycie chlopaka z losowymi awariami, stosujac
%  polityke U z programu 1. Srednia z J powinna dazyc do V_0(x0).
%  
% =========================================================================
clear; clc;
parametry;
load wyniki_P1.mat        % wczytuje V i U

M = 10000;                % liczba symulacji (prob)
J = zeros(1, M);          % zadowolenie w kazdej probie
F = cumsum(p);            % dystrybuanta: [0.5 0.8 0.95 1]
rng(1);                   % stale ziarno -> powtarzalne wyniki

for m = 1:M
    x = x0;
    for k = 0:N
        i = min(nx, round(x/dx) + 1);   % indeks stanu na siatce
        u = U(k+1, i);                  % decyzja z polityki
        J(m) = J(m) + beta^k * sqrt(u);
        if k < N
            % Losowanie awarii metoda odwrotnej dystrybuanty:
            % r z [0,1]; wybieramy pierwszy przedzial, w ktorym r <= F(l)
            r = rand;
            l = find(r <= F, 1);
            % (to samo daje: wk = randsample(w, 1, true, p);)
            x = max(0, (1+alpha)*(x - u - w(l)));
        end
    end
end

Jsr = cumsum(J) ./ (1:M);          % srednia z dotychczasowych prob
V0  = V(1, round(x0/dx) + 1);      % wartosc oczekiwana z programu 1

fprintf('V_0(x0) z programu 1:   %.4f\n', V0);
fprintf('Srednia z %d symulacji: %.4f\n', M, Jsr(end));
fprintf('Roznica:                %.4f (%.2f%%)\n', Jsr(end)-V0, 100*(Jsr(end)-V0)/V0);
fprintf('Odchylenie std. J:      %.4f\n', std(J));

% --- Wykres: zbieznosc sredniej do V_0(x0) --------------------------------
figure;
semilogx(1:M, Jsr, 'LineWidth', 1.2); hold on; grid on;
yline(V0, 'r--', 'LineWidth', 1.5);
xlabel('liczba symulacji'); ylabel('srednia J');
legend('srednia z dotychczasowych symulacji', 'V_0(x_0) z programu 1');
title('Zbieznosc sredniej do wartosci oczekiwanej');

% --- Wykres: rozklad wynikow J --------------------------------------------
figure; histogram(J, 40); grid on;
xlabel('J'); ylabel('liczba prob'); title('Rozklad lacznego zadowolenia J');
