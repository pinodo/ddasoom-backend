package com.paw.ddasoom;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableJpaAuditing
@EnableScheduling // Spring Scheduler 사용
@SpringBootApplication
public class DdasoomApplication {

	public static void main(String[] args) {
		SpringApplication.run(DdasoomApplication.class, args);
	}

}
