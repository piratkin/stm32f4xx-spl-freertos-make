#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"
#include "event_groups.h"
#include "timers.h"

#include "stm32f4xx.h"
#include "stm32f4xx_rcc.h"

static void init(void);
static void task(void* pvParameters);

#define UNUSED(x)   (void)(x)

int main(void)
{
    
    init();

    xTaskCreate(task, "tt", 16, 0, 5, NULL);
    
    vTaskStartScheduler();
    
    return 0;
}

static void init(void)
{
    SystemCoreClockUpdate();
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_4);
}

static
unsigned int
count = 0;

static void task(void* pvParameters)
{
    UNUSED(pvParameters);

    while(1)
    {
        count++;
    }
}
