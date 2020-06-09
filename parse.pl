#!/usr/bin/perl
$/ = undef;
while(<>) {
	print "#include <SDL2/SDL.h>\n#include <stdint.h>\n\n";
	s/.include ([^;]+);/#include "\1"/g;
	s/^include ([^;]+);/#include <\1>/g;
	s/entry:/int main(void) {/g;
	s/entry ([A-z][A-z0-9]*)\s*,\s*([A-z][A-z0-9]*)\s*:/int main(int \1, char* \2\[\]) {\n\tSDL_Init(SDL_INIT_EVERYTHING);/g;
	s/([A-z][A-z0-9]*)\s+:u(8|16|32|64)(\**)/uint\2_t\3 \1/g;
	s/([A-z][A-z0-9]*)\s+:(8|16|32|64)(\**)/int\2_t\3 \1/g;
	s/([A-z][A-z0-9]*)\s+:Color\s+({[^}]+})/struct { uint8_t r, g, b, a; }\1 = \2/g;
	s/([A-z][A-z0-9]*)\s+:Color/struct\s+{ uint8_t r, g, b, a; }\1;/g;
	s/([A-z][A-z0-9]*)\s+:-([A-z][A-z0-9]*)/struct \2 \1/g;
	s/([A-z][A-z0-9]*)\s+:Win\s*{([^}]+)}/SDL_Window* \1 = SDL_CreateWindow(\2)/g;
	s/([A-z][A-z0-9]*)\s+:Win/SDL_Window* \1/g;
	s/([A-z][A-z0-9]*)\s+:Ren\s*{([^}]+)}/SDL_Renderer* \1 = SDL_CreateRenderer(\2)/g;
	s/([A-z][A-z0-9]*)\s+:Ren/SDL_Renderer* \1/g;
	s/@([A-z][A-z0-9]*)\s*\(([^)]+)\)/typedef struct \1 {\2} \1;/g;
	s/([A-z][A-z0-9]*)\s+:@@\s*\(([^)]+)\)/struct {\2}\1;/g;
	s/@/struct /g;
	s/([A-z][A-z0-9]*)\s+:([A-z][A-z0-9]*) ({[^}]*})/\2 \1 = \3/g;
	s/([A-z][A-z0-9]*)\s+:([A-z][A-z0-9]*)/\2 \1/g;
	s/Wait\s+a\s+minute!!!/SDL_Delay(60*1000);/g;
	s/wait\s+([0-9bx]+)/SDL_Delay(\1)/g;
	s/clear\s+([A-z][A-z0-9]*)/SDL_RenderClear(\1)/g;
	s/set\s+([A-z][A-z0-9]*)\s+color\s+to\s+([A-z][A-z0-9]*)/SDL_SetRenderDrawColor(\1, \2.r, \2.g, \2.b, \2.a)/g;
	s/set\s+([A-z][A-z0-9]*)\s+([A-z][A-z0-9]*)\s+to\s+([A-z0-9*\/+-]+)/\1.\2 = \3/g;
	s/show\s+([A-z][A-z0-9]*)/SDL_RenderPresent(\1)/g;
	s/([A-z][A-z0-9]*)\s([A-z][A-z0-9]*\**)\s+([A-z][A-z0-9]*)\s*:/void \1(\2 \3) {/g;
	s/([A-z][A-z0-9]*)\s*:/void \1(void) {/g;
	s/-!-/}/g;
	print;
}

print "\n";