package no.entur.devops;


import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

public class ModuleSizeCalculator {
	
	public static final void main(String[] args) throws IOException {
		Map<String, Long> moduleSizes = getModuleSizes();

		long totalSize = 0;

		int maxLength;
		if(args.length == 0) {
			maxLength = printModuleSizes(moduleSizes);
			
			for (Entry<String, Long> entry : moduleSizes.entrySet()) {
				totalSize += entry.getValue();
			}
		} else {
			String selectedModulesString = args[0]; // "java.base,java.compiler,java.desktop,java.instrument,java.management,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.security.jgss,java.security.sasl,java.sql,java.xml.crypto,jdk.httpserver,jdk.jfr,jdk.unsupported,jdk.xml.dom";
			
			HashSet<String> selectedModuleNames = new HashSet<>();
	
			for(String module : selectedModulesString.split(",")) {
				
				if(!moduleSizes.containsKey(module)) {
					System.out.println("Unknown module " + module + ", only know of the following:" );
					printModuleSizes(moduleSizes);
					System.exit(1);

				}
				
				selectedModuleNames.add(module);
			}
	
			long selectedModulesSize = 0;
			
			Map<String, Long> selectedModules = new HashMap<>();
			
			for (Entry<String, Long> entry : moduleSizes.entrySet()) {
				totalSize += entry.getValue();
				if(selectedModuleNames.contains(entry.getKey())) {
					selectedModulesSize += entry.getValue();
					
					selectedModules.put(entry.getKey(), entry.getValue());
				}
			}
			
			maxLength = printModuleSizes(selectedModules);
			
			printFormattedSum(totalSize, selectedModulesSize, maxLength, "Sum");
		}
		printFormattedSum(totalSize, totalSize, maxLength, "Total sum");
	}

	private static void printFormattedSum(long totalSize, long selectedModulesSize, int maxLength, String m) {
		String selectedSize = Long.toString(selectedModulesSize/1024);
		String message = m + " (" + ((selectedModulesSize * 100)/totalSize) + "%)";

		System.out.print(message);
		for(int i = message.length() + selectedSize.length() + 2; i < maxLength; i++) {
			System.out.print(' ');
		}
		System.out.println(selectedSize);

		for(int i = 0; i < maxLength - 2; i++) {
			System.out.print('-');
		}
		System.out.println();
	}

	private static int printModuleSizes(Map<String, Long> selectedModuleSizes) {
		System.out.println();
		System.out.println("Module sizes (in KB):");

		int maxLength = 0;
		for (Entry<String, Long> entry : selectedModuleSizes.entrySet()) {
			String key = entry.getKey();
			String value = Long.toString(entry.getValue()/1024);
			
			int l = key.length() + value.length();
			if(maxLength < l) {
				maxLength = l;
			}
		}
		
		for (Entry<String, Long> entry : selectedModuleSizes.entrySet()) {
			String key = entry.getKey();
			String value = Long.toString(entry.getValue()/1024);
			
			System.out.print(entry.getKey());
			
			for(int i = key.length() + value.length(); i < maxLength; i++) {
				System.out.print(' ');
			}
			
			for(int i = 0; i < 10; i++) {
				System.out.print(" ");
			}
			System.out.println(value);
		}
		for(int i = 0; i < maxLength + 10;  i++) {
			System.out.print('-');
		}
		System.out.println();

		return maxLength + 10 + 2;
	}
	
	public static Map<String, Long> getModuleSizes() throws IOException {
		String javaHome = System.getProperty("java.home");

		Map<String, Long> results = new HashMap<>();
		
	    Path p = Path.of(javaHome).resolve("lib").resolve("jrt-fs.jar");
        try(URLClassLoader loader = new URLClassLoader(new URL[]{ p.toUri().toURL() });
            FileSystem fs = FileSystems.newFileSystem(URI.create("jrt:/"), Collections.emptyMap(), loader)) {
            
        	List<Path> paths = Files.list(fs.getPath("/modules")).collect(Collectors.toList());
        	
        	for (Path path : paths) {

        		long sum = Files.walk(path).mapToLong(l -> {
    				try {
    					return Files.size(l);
    				} catch (IOException e) {
    					throw new RuntimeException(e);
    				}
    			}).sum();
        		
        		results.put(path.getFileName().toString(), sum);
			}
        }
        
        return results;
	}
	
}

