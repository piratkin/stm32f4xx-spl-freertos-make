#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"
#include "event_groups.h"
#include "timers.h"

#define STACK_DEPTH  configMINIMAL_STACK_SIZE
#define PRIORITY     tskIDLE_PRIORITY

#include "stm32f4xx.h"
#include "stm32f4xx_rcc.h"

static void init(void);
static void t(void* pvParameters);

#define UNUSED(x)    (void)(x)

#define MAX_TASKS    1024

int taskId;
TaskHandle_t xHandle[MAX_TASKS];
BaseType_t xReturned;

int main(void)
{
    
    init();

    for (taskId = 0; taskId < MAX_TASKS; taskId++)
    {
        xReturned = xTaskCreate(t, "#", STACK_DEPTH, (void*)taskId, PRIORITY, &xHandle[taskId]);
        
        if (xReturned != pdPASS)
        {
            break;
        }
        
        taskId++;
    }
    
    vTaskStartScheduler();
    
    while(1);
    
    return 0;
}

static void init(void)
{
    SystemCoreClockUpdate();
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_4);
}

static void t(void* pvParameters)
{
    UNUSED(pvParameters);

    static
    unsigned int
    count = 0;
    
    while(1)
    {
        count++;
    }
}
