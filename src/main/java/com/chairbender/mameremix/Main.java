package com.chairbender.mameremix;

import org.apache.commons.io.FileUtils;

import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.List;

public class Main {
    private static final String INPUT_FILE = "mame199/luainput.txt";
    private static final String OUTPUT_FILE = "mame199/luaoutput.txt";

    public static void main(String[] args) throws IOException, InterruptedException {
        Map<String, List<String>> gamesToStates = getGamesToStates();
        List<String> keys = new ArrayList<>(gamesToStates.keySet());

        while (true) {
            Random rnd = new Random();
            String game = keys.get(rnd.nextInt(keys.size()));
            List<String> states = gamesToStates.get(game);
            String state = states.get(rnd.nextInt(states.size()));

            FileUtils.write(new File(INPUT_FILE), game + "\n" + state, "UTF-8");

            //set up the save state (to slot 9)
            File stateFile = new File("minigame_states/" + game + "/" + state + ".sta");
            File target = new File("mame199/sta/" + game + "/9.sta");
            target.getParentFile().mkdirs();
            FileUtils.copyFile(stateFile, target);

            //start the game
            System.out.println("Playing " + game + " on state " + state);
            System.out.println("Press enter to continue...");
            System.in.read();

            ProcessBuilder builder = new ProcessBuilder();
            File mamefolder = new File("mame199");
            System.out.println("Mame folder " + mamefolder.getAbsolutePath());
            builder.directory(mamefolder);
            builder.command("CMD", "/C", "mame64.exe " + game + " -window -script plugins/remix/autoboot.lua -state 9");
            Process process = builder.start();

            process.waitFor();

            //check result
            File outputFile = new File(OUTPUT_FILE);
            outputFile.createNewFile();

            String output = FileUtils.readFileToString(new File(OUTPUT_FILE), "UTF-8");
            if (output.trim().equals("1")) {
                System.out.println("You won! Good Job! Next...");
            } else {
                System.out.println("You messed up, bucko. Next...");
            }
        }
    }

    private static Map<String, List<String>> getGamesToStates() {
        Map<String, List<String>> result = new HashMap<>();

        //get the folder
        File minigameStatesFolder = new File("minigame_states");


        for (File file : minigameStatesFolder.listFiles()) {
            String game = file.getName();

            List<String> states = new ArrayList<>();
            for (File stateFile : file.listFiles()) {
                if (stateFile.getName().endsWith(".sta")) {
                    states.add(stateFile.getName().replaceAll("\\.sta", ""));
                }
            }
            result.put(game, states);
        }

        return result;
    }
}
