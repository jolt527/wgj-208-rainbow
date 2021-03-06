if (state == TitleState.INITIAL_WAIT && initialWaitFramesLeft <= 0) {
	state = TitleState.FADE_IN_MAIN_GRAPHICS;

	audio_play_sound(musTitle, 0, true);
} else if (state == TitleState.FADE_IN_MAIN_GRAPHICS && fadeInMainGraphicsFramesLeft <= 0) {
	state = TitleState.FADE_IN_ALL_TEXT;
} else if (state == TitleState.FADE_IN_ALL_TEXT && fadeInAllTextFramesLeft <= 0) {
	state = TitleState.ALLOW_PLAYER_INPUT;
} else if (state == TitleState.ALLOW_PLAYER_INPUT && oInput.menuSelectWasPressed) {
	if (selectedMenuOption == 1) {
		state = TitleState.SHOW_CREDITS;
		startingToShowCredits = true;
		audio_play_sound(sndCrystalPickup, 10, false);
	} else {
		state = TitleState.FADE_OUT;

		audio_play_sound(sndCrystalPickup, 10, false);
	}
} else if (state == TitleState.FADE_OUT && fadeOutFramesLeft <= 0) {
	if (selectedMenuOption == 0) {
		room_goto_next();
	} else if (selectedMenuOption == 2) {
		game_end();
	}
}



switch (state) {
	case TitleState.INITIAL_WAIT: {
		initialWaitFramesLeft--;
	} break;

	case TitleState.FADE_IN_MAIN_GRAPHICS: {
		fadeInMainGraphicsFramesLeft--;
		allBlackAlpha = lerp(1, 0, 1 - fadeInMainGraphicsFramesLeft / TOTAL_FADE_IN_MAIN_GRAPHICS_FRAMES);
	} break;

	case TitleState.FADE_IN_ALL_TEXT: {
		fadeInAllTextFramesLeft--;
		allTextAlpha = lerp(0, 1, 1 - fadeInAllTextFramesLeft / TOTAL_FADE_IN_ALL_TEXT_FRAMES);
	} break;

	case TitleState.ALLOW_PLAYER_INPUT: {
		if (oInput.menuUpWasPressed) {
			audio_play_sound(sndMenuMove, 10, false);
			selectedMenuOption--;
			if (selectedMenuOption < 0) {
				selectedMenuOption = MENU_OPTIONS_SIZE - 1;
			}
		} else if (oInput.menuDownWasPressed) {
			audio_play_sound(sndMenuMove, 10, false);
			selectedMenuOption++;
			if (selectedMenuOption >= MENU_OPTIONS_SIZE) {
				selectedMenuOption = 0;
			}
		}
	} break;

	case TitleState.FADE_OUT: {
		fadeOutFramesLeft--;
		allBlackAlpha = lerp(0, 1, 1 - fadeOutFramesLeft / TOTAL_FADE_OUT_FRAMES);
	} break;

	case TitleState.SHOW_CREDITS: {
		if (!startingToShowCredits && oInput.anyKeyWasPressed) {
			state = TitleState.ALLOW_PLAYER_INPUT;
			audio_play_sound(sndMenuMove, 10, false);
		}
		startingToShowCredits = false;
	} break;

	default: {
		// do nothing
	}
}



redCrystalAngle += CRYSTAL_ROTATION_SPEED;
greenCrystalAngle += CRYSTAL_ROTATION_SPEED;
blueCrystalAngle += CRYSTAL_ROTATION_SPEED;

clockwise_shine_angle += CLOCKWISE_SHINE_ROTATION_SPEED;
counter_clockwise_shine_angle += COUNTER_CLOCKWISE_SHINE_ROTATION_SPEED;

gameNameHue++;
if (gameNameHue > 255) {
	gameNameHue = 0;
}
