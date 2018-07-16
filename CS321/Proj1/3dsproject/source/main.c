
#include <3ds.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
//This include a header containing definitions of our image
#include "brew_bgr.h"

int main(int argc, char **argv) {

	gfxInitDefault();
	consoleInit(GFX_TOP, NULL);

	//simple string printing
	printf("\x1b[30;15H \x1b[47;35mHello CS321 Class\x1b[0m\x1b \n");
	printf("\x1b[21;16HPress Start to exit.");

	//buffer for bottom screen
	gfxSetDoubleBuffering(GFX_BOTTOM, false);

	//framebuffer for bottom
	u8* fb = gfxGetFramebuffer(GFX_BOTTOM, GFX_LEFT, NULL, NULL);

	//Copy our image in the bottom screen's frame buffer
	memcpy(fb, brew_bgr, brew_bgr_size);


	// Main loop
	while (aptMainLoop()) {

		gfxSwapBuffers();
		gfxFlushBuffers();
		gspWaitForVBlank();
		hidScanInput();

		touchPosition touch;
		//Read the touch screen coordinates
		hidTouchRead(&touch);

		//Print the touch screen coordinates
		printf("\x1b[1;0HTouchscreen position: %03d; %03d", touch.px, touch.py);

		u32 kDown = hidKeysDown();

		if (kDown & KEY_DOWN)
			printf("\n\nThat's the DOWN button!");
		if (kDown & KEY_UP)
			printf("\n\nThat's the UP button!");
		if (kDown & KEY_LEFT)
			printf("\n\nThat's the LEFT button!");
		if (kDown & KEY_RIGHT)
			printf("\n\nThat's the RIGHT button!");

		if (kDown & KEY_START)
			break; // break in order to return to hbmenu
	}
	gfxExit();
	return 0;
}
