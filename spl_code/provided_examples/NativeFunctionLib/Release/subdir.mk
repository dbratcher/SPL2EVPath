################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../LibFunctions.cpp 

CPP_DEPS += \
./LibFunctions.d 

OBJS += \
./LibFunctions.o 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O3 -Wall -c -fmessage-length=0 -D_REENTRANT -fPIC -isystem/home/streamsadmin/Streams-2.0.0.4/include -isystem/home/streamsadmin/Streams-2.0.0.4/system/impl/include -isystem/home/streamsadmin/Streams-2.0.0.4/ext/include -isystem/home/streamsadmin/Streams-2.0.0.4/ext/include/decNumber -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


