#include <string.h>
#include <stdio.h>

#include <switch.h>

int main(int argc, char **argv)
{

	//Matrix containing the name of each key. Useful for printing when a key is pressed
    char keysNames[32][32] = {
        "KEY_A", "KEY_B", "KEY_X", "KEY_Y",
        "KEY_LSTICK", "KEY_RSTICK", "KEY_L", "KEY_R",
        "KEY_ZL", "KEY_ZR", "KEY_PLUS", "KEY_MINUS",
        "KEY_DLEFT", "KEY_DUP", "KEY_DRIGHT", "KEY_DDOWN",
        "KEY_LSTICK_LEFT", "KEY_LSTICK_UP", "KEY_LSTICK_RIGHT", "KEY_LSTICK_DOWN",
        "KEY_RSTICK_LEFT", "KEY_RSTICK_UP", "KEY_RSTICK_RIGHT", "KEY_RSTICK_DOWN",
        "KEY_SL", "KEY_SR", "KEY_TOUCH", "",
        "", "", "", ""
    };

	u32 kDownOld = 0, kHeldOld = 0, kUpOld = 0; //In these variables there will be information about keys detected in the previous frame

    printf("\x1b[1;1HPress PLUS to exit.");

    gfxInitDefault();
    consoleInit(NULL);


    // // clear screen and home cursor
    // printf( CONSOLE_ESC(2J) );

    // move cursor left
    // /x1b[columnsD
	printf("\x1B[4m\033[1;33mCameron K. Titus");
	printf(CONSOLE_ESC(0m));
	printf(CONSOLE_ESC(7m)"\x1b[3;3H\033[1;31mChris Bailey");
	printf(CONSOLE_ESC(0m));
	printf(CONSOLE_ESC(4m)"\x1b[5;5H\033[1;35mBradley Morton");
	printf(CONSOLE_ESC(0m));
	printf(CONSOLE_ESC(7m)"\x1b[7;9H\033[1;32mBrandon Abbott");
	printf("\n");
	printf(CONSOLE_ESC(0m));
	printf(CONSOLE_ESC(2m) CONSOLE_ESC(9m) "\x1b[10;10H\033[1;37m Nintendo Security is really good  ");
    

    // Main loop
    while(appletMainLoop())
    {
        //Scan all the inputs. This should be done once for each frame
        hidScanInput();

        // Your code goes here

        //hidKeysDown returns information about which buttons have been just pressed (and they weren't in the previous frame)
        u32 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
		u32 kHeld = hidKeysHeld(CONTROLLER_P1_AUTO);
        //hidKeysUp returns information about which buttons have been just released
        u32 kUp = hidKeysUp(CONTROLLER_P1_AUTO);

        if (kDown & KEY_PLUS) break; // break in order to return to hbmenu

		//Do the keys printing only if keys have changed
        if (kDown != kDownOld || kHeld != kHeldOld || kUp != kUpOld)
        {
            //Clear console
            consoleClear();

            //These two lines must be rewritten because we cleared the whole console
            printf("\x1b[1;H\033[0;35mPress PLUS to exit.");

            printf("\x1b[6;1H"); //Move the cursor to the sixth row because on the previous ones we'll write the joysticks' position

            //Check if some of the keys are down, held or up
            int i;
            for (i = 0; i < 32; i++)
            {
                if (kDown & BIT(i)) printf("%s down\n", keysNames[i]);
                if (kHeld & BIT(i)) printf("%s held\n", keysNames[i]);
                if (kUp & BIT(i)) printf("%s up\n", keysNames[i]);
            }
        }

        //Set keys old values for the next frame
        kDownOld = kDown;
        kHeldOld = kHeld;
        kUpOld = kUp;

        gfxFlushBuffers();
        gfxSwapBuffers();
        gfxWaitForVsync();
    }

    gfxExit();
    return 0;
}

