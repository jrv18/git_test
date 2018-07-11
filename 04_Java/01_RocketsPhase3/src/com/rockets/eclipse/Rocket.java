package com.rockets.eclipse;

import java.util.List;
//import java.util.List;
import java.util.ArrayList;
import com.rockets.eclipse.Engine;

public class Rocket {
	private static final int DEFAULT_POWER = 0;  
	private String id;
	private List<Engine> engine;
	private int speed = 0;

	public Rocket(String id, int engines) {
		super();
		this.id = id;
		this.engine = new ArrayList<Engine>(); // Creates an empty ArrayList
		for (int i = 0; i < engines; i++) {
			addEngine(DEFAULT_POWER); 
		}
		this.speed = 0;
	}

	public Rocket(String id, int[] powerOfEngines) {
		super();
		this.id = id;
		this.engine = new ArrayList<Engine>();
		for (int i = 0; i < powerOfEngines.length; i++) {
			addEngine(powerOfEngines[i]);
		}
		this.speed = 0;
	}

	public String getId() {
		return this.id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getSpeed() {
		return this.speed;
	}

	public void setSpeed(int speed) {
		this.speed = speed;
	}

	/** 
	 * @param power    The power to assign to the engine 
	 * 
	 * The following line:
	 * 		this.engine.add(new Engine(power)); 
	 *  
	 *  is equivalent to the these two lines of code.       
	 *      Engine theEngine = new Engine(power);
	 *      this.engine.add(theEngine);  
	 **/
	public void addEngine(int power) {
		this.engine.add(new Engine(power)); 
	}

	/** 
	 * @param engineId The identifier of the engine inside the ArrayList<Engine>
	 *        power    The power to assign to the engine 
	 *        
	 * The following line:       
	 * 		this.engine.get(engineId).setPower(power);  
	 * 		
	 * is equivalent to these two lines of code:
	 * 		Engine theEngine = this.engine.get(engineId);
	 *		theEngine.setPower(power);
	 **/
	public void setEngine(int engineId, int power) {
		this.engine.get(engineId).setPower(power);
	}

	/**
	 * 
	 * @param time Amount of time that the rocket engines transfer power to give force of acceleration.
	 * 
	 *  I assume that the power of the rocket is the sum of the power of each engine.
	 *  I assume that each engine works at full power for this time.
	 */
	public void accelerate(int times) {
		int totalPower = 0;
		for (int engineId = 0; engineId < engine.size(); engineId++) {
			totalPower = totalPower + this.engine.get(engineId).getPower();
		}
		this.speed += (totalPower * times);
	}
	public void accelerate() {
		int totalPower = 0;
		for (int engineId = 0; engineId < engine.size(); engineId++) {
			totalPower = totalPower + this.engine.get(engineId).getPower();
		}
		this.speed += totalPower;
	}

	public void decelerate(int times) {
		int totalPower = 0;
		for (int engineId = 0; engineId < engine.size(); engineId++) {
			totalPower = totalPower + this.engine.get(engineId).getPower();
		}
		this.speed -= (totalPower * times);
		if (this.speed < 0) {
			this.speed = 0;
		} 
	}
	public void decelerate() {
		int totalPower = 0;
		for (int engineId = 0; engineId < engine.size(); engineId++) {
			totalPower = totalPower + this.engine.get(engineId).getPower();
		}
		this.speed -= totalPower;
		    if (this.speed < 0) {
			this.speed = 0;
		}
	}

	@Override
	public String toString() {
		String myStr = new String();
		myStr = this.id.toString() + ": ";

		int engineId = 0;
		while (engineId < this.engine.size()-1) {
			myStr = myStr + this.engine.get(engineId).toString() + ",";
			engineId++;
		}
		myStr = myStr + this.engine.get(engineId).toString();
		return myStr;
	}

}
