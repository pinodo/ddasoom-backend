package com.paw.ddasoom.animal.util;

import org.springframework.core.convert.converter.Converter;

import com.paw.ddasoom.animal.domain.AnimalGender;

// animal/converter/AnimalGenderConverter.java
public class AnimalGenderConverter implements Converter<String, AnimalGender> {

    @Override
    public AnimalGender convert(String value) {
        return AnimalGender.from(value);
    }
}