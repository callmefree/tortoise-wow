
#include "playerbot/playerbot.h"
#include "playerbot/PlayerbotAIConfig.h"
#include "playerbot/PlayerbotFactory.h"
#include "PlayerbotCommandServer.h"

INSTANTIATE_SINGLETON_1(PlayerbotCommandServer);

void PlayerbotCommandServer::Start()
{
    // Command server functionality is disabled (requires boost::asio)
    // This feature can be re-enabled by implementing a std::net based solution
    if (sPlayerbotAIConfig.commandServerPort) {
        sLog.outString("Playerbot Command Server is disabled (requires boost::asio)");
    }
}
