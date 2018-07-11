package com.rockets.eclipse;

import com.rockets.eclipse.Rocket;

public class RocketPhase3 {
	public static final String ROCKET1_ID ="32WESSDS"; 
	public static final String ROCKET2_ID ="LDSFJA32";
	public static final int ROCKET1_ENGINES = 3;
	public static final int ROCKET2_ENGINES = 6;
	public static final int ROCKET1 = 1;
	public static final int ROCKET2 = 2;
	public static final int[] ROCKET1_ENGINE_MAX_POWER = {10,30,80};
	public static final int[] ROCKET2_ENGINE_MAX_POWER = {30,40,50,50,30,10};

	public static void main(String[] args) {
		System.out.println("===== RocketPhase3 =====");
		testRocketsPhase3();
	}

	public static void testRocketsPhase3() {
		Rocket myRocket1, myRocket2;

		myRocket1 = new Rocket(ROCKET1_ID, ROCKET1_ENGINE_MAX_POWER);
		myRocket2 = new Rocket(ROCKET2_ID, ROCKET2_ENGINE_MAX_POWER);
		System.out.println( "2: Engines and max power of each one");
		showRocketPhase3(myRocket1);
		showRocketPhase3(myRocket2);
		
		System.out.println( "3: Speed of the rockets");
		showRocketSpeed(myRocket1, myRocket2);

		System.out.println( "4: Accelerate 3 times both rockets");
		myRocket1.accelerate(3);
		myRocket2.accelerate(3);

		System.out.println( "5: Speed of the rockets");
		showRocketSpeed(myRocket1, myRocket2);
		
		System.out.println( "6: Decelerate 5 times rocket '32WESSDS' and accelerate 7 times rocket 'LDSFJA32'");
		myRocket1.decelerate(5);
		myRocket2.accelerate(7);

		System.out.println( "7: Speed of the rockets");
		showRocketSpeed(myRocket1, myRocket2);

		System.out.println( "8: Accelerate 15 times both rockets");
		myRocket1.accelerate(15);
		myRocket2.accelerate(15);
		
		System.out.println( "9: Speed of the rockets");
		showRocketSpeed(myRocket1, myRocket2);
	}

	public static void showRocketSpeed(Rocket Rocket1, Rocket Rocket2) {
		showRocketSpeed(Rocket1);
		showRocketSpeed(Rocket2);
	}

	public static void showRocketSpeed(Rocket myRocket) {
		System.out.println( myRocket.getId() + ": " + String.valueOf(myRocket.getSpeed()) + " [m/s]" );
	}

	public static void showRocketPhase3(Rocket myRocket) {
		System.out.println( myRocket.toString());
	}

}
