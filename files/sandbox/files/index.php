<?php

use parallel\{Channel, Runtime};

/**
 * simple thread manager with one producer and $nrThreads consumers.
 */
class ThreadManager
{

    private static $consumers = [];
    private static $producer;
    private static $nrConsumers;
    private static $consumerTask;
    private static $producerTask;

    public static function init(int $nrThreads, Closure $produce, Closure $consume)
    {
        echo "init" . PHP_EOL;
        self::$nrConsumers = $nrThreads;
        self::$consumerTask = $consume;
        self::$producerTask = $produce;

        for ($i = 0; $i < self::$nrConsumers; ++$i) {
            $threadId = uniqid();
            self::$consumers[$threadId] = new Runtime();
        }

        self::$producer = new Runtime();
    }

    public static function start(): void
    {
        echo "start" . PHP_EOL;
        self::$producer->run(
            function (Closure $closure, int $nrThreads) {
                $closure($nrThreads);
            },
            [self::$producerTask, self::$nrConsumers]
        );

        foreach (self::$consumers as $key => $consumer) {
            $consumer->run(
                self::$consumerTask,
                [$key]
            );
        }
    }

    public static function finalize(): void
    {
        echo "finalize" . PHP_EOL;
        self::$producer->close();
        foreach (self::$consumers as $consumer) {
            $consumer->close();
        }
    }
}

/**
 * nr threads
 */
$nrThreads = 4;

/**
 * consumer task
 */
$consumeTask = function (string $taskId) {
    $channel = Channel::open("data_channel");
    echo "run task #{$taskId}" . PHP_EOL;
    while (($data = $channel->recv()) != null) {
        echo "[{$taskId}] consumer sleeps {$data} seconds" . PHP_EOL;
        sleep($data);
    }
    echo "consumer {$taskId} stops" . PHP_EOL;
};

/**
 * produser task
 */
$produceTask = function (int $nrConsumers) {
    $reads = 0;
    $channel = Channel::open("data_channel");
    echo "run producer" . PHP_EOL;
    while ($reads++ < 50) {
        $data = [random_int(1, 5), random_int(1, 5), random_int(1, 5), random_int(1, 5),];
        foreach ($data as $value) {
            echo "[producer] simulate read data, readed {$value}" . PHP_EOL;
            $channel->send($value);
        }
        sleep(5);
    }
    for ($i = 0; $i < $nrConsumers; ++$i) {
        $channel->send(null);
    }
    echo "producer stops" . PHP_EOL;
};

/**
 * channel for communication between producer and consumers
 */
$channel = Channel::make("data_channel");

ThreadManager::init($nrThreads, $produceTask, $consumeTask);

ThreadManager::start();

ThreadManager::finalize();
