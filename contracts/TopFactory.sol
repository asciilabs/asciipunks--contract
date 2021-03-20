// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TopFactory {
    function _chooseTop(uint256 rand) internal pure returns (string memory) {
        string[56] memory tops =
            [
                unicode"   ┌───┐    \n"
                unicode"   │   ┼┐   \n"
                unicode"   ├────┼┼  \n",
                unicode"   ┌┬┬┬┬┐   \n"
                unicode"   ╓┬┬┬┬╖   \n"
                unicode"   ╙┴┴┴┴╜   \n",
                unicode"   ╒════╕   \n"
                unicode"  ┌┴────┴┐  \n"
                unicode"  └┬────┬┘  \n",
                unicode"   ╒════╕   \n"
                unicode"   │□□□□│   \n"
                unicode"  └┬────┬┘  \n",
                unicode"   ╒════╕   \n"
                unicode"   │    │   \n"
                unicode" └─┬────┬─┘ \n",
                unicode"    ◛◛◛◛    \n"
                unicode"   ▄████▄   \n"
                unicode"   ┌────┐   \n",
                unicode"    ◙◙◙◙    \n"
                unicode"   ▄████▄   \n"
                unicode"   ┌────┐   \n",
                unicode"   ┌───┐    \n"
                unicode"┌──┤   └┐   \n"
                unicode"└──┼────┤   \n",
                unicode"    ┌───┐   \n"
                unicode"   ┌┘   ├──┐\n"
                unicode"   ├────┼──┘\n",
                unicode"   ┌────┐/  \n"
                unicode"┌──┴────┴──┐\n"
                unicode"└──┬────┬──┘\n",
                unicode"   ╒════╕   \n"
                unicode" ┌─┴────┴─┐ \n"
                unicode" └─┬────┬─┘ \n",
                unicode"  ┌──────┐  \n"
                unicode"  │▲▲▲▲▲▲│  \n"
                unicode"  └┬────┬┘  \n",
                unicode"  ┌┌────┐┐  \n"
                unicode"  ││┌──┐││  \n"
                unicode"  └┼┴──┴┼┘  \n",
                unicode"   ┌────┐   \n"
                unicode"  ┌┘─   │   \n"
                unicode"  └┌────┐   \n",
                unicode"            \n"
                unicode"   ┌┬┬┬┬┐   \n"
                unicode"   ├┴┴┴┴┤   \n",
                unicode"            \n"
                unicode"    ╓┬╥┐    \n"
                unicode"   ┌╨┴╨┴┐   \n",
                unicode"            \n"
                unicode"   ╒╦╦╦╦╕   \n"
                unicode"   ╞╩╩╩╩╡   \n",
                unicode"            \n"
                unicode"            \n"
                unicode"   ┌┼┼┼┼┐   \n",
                unicode"            \n"
                unicode"    ││││    \n"
                unicode"   ┌┼┼┼┼┐   \n",
                unicode"      ╔     \n"
                unicode"     ╔║     \n"
                unicode"   ┌─╫╫─┐   \n",
                unicode"            \n"
                unicode"    ║║║║    \n"
                unicode"   ┌╨╨╨╨┐   \n",
                unicode"            \n"
                unicode"   ▐▐▐▌▌▌   \n"
                unicode"   ┌────┐   \n",
                unicode"            \n"
                unicode"   \\/////   \n"
                unicode"   ┌────┐   \n",
                unicode"    ┐ ┌     \n"
                unicode"   ┐││││┌   \n"
                unicode"   ┌────┐   \n",
                unicode"  ┌┐ ┐┌┐┌┐  \n"
                unicode"  └└┐││┌┘   \n"
                unicode"   ┌┴┴┴┴┐   \n",
                unicode"  ┐┐┐┐┐     \n"
                unicode"  └└└└└┐    \n"
                unicode"   └└└└└┐   \n",
                unicode"            \n"
                unicode"   ││││││   \n"
                unicode"   ┌────┐   \n",
                unicode"            \n"
                unicode"    ╓╓╓╓    \n"
                unicode"   ┌╨╨╨╨┐   \n",
                unicode"    ╔╔╗╗╗   \n"
                unicode"   ╔╔╔╗╗╗╗  \n"
                unicode"  ╔╝╝║ ╚╚╗  \n",
                unicode"   ╔╔╔╔╔╗   \n"
                unicode"  ╔╔╔╔╔╗║╗  \n"
                unicode"  ╝║╨╨╨╨║╚  \n",
                unicode"   ╔╔═╔═╔   \n"
                unicode"   ╔╩╔╩╔╝   \n"
                unicode"   ┌────┐   \n",
                unicode"            \n"
                unicode"     ///    \n"
                unicode"   ┌────┐   \n",
                unicode"     ╔╗╔╗   \n"
                unicode"    ╔╗╔╗╝   \n"
                unicode"   ┌╔╝╔╝┐   \n",
                unicode"     ╔╔╔╔╝  \n"
                unicode"    ╔╝╔╝    \n"
                unicode"   ┌╨╨╨─┐   \n",
                unicode"       ╔╗   \n"
                unicode"    ╔╔╔╗╝   \n"
                unicode"   ┌╚╚╝╝┐   \n",
                unicode"   ╔════╗   \n"
                unicode"  ╔╚╚╚╝╝╝╗  \n"
                unicode"  ╟┌────┐╢  \n",
                unicode"    ╔═╗     \n"
                unicode"    ╚╚╚╗    \n"
                unicode"   ┌────┐   \n",
                unicode"            \n"
                unicode"            \n"
                unicode"   ┌╨╨╨╨┐   \n",
                unicode"            \n"
                unicode"    ⌂⌂⌂⌂    \n"
                unicode"   ┌────┐   \n",
                unicode"   ┌────┐   \n"
                unicode"   │   /└┐  \n"
                unicode"   ├────┐/  \n",
                unicode"            \n"
                unicode"   ((((((   \n"
                unicode"   ┌────┐   \n",
                unicode"   ┌┌┌┌┌┐   \n"
                unicode"   ├┘┘┘┘┘   \n"
                unicode"   ┌────┐   \n",
                unicode"   «°┐      \n"
                unicode"    │╪╕     \n"
                unicode"   ┌└┼──┐   \n",
                unicode"  <° °>   § \n"
                unicode"   '/   /  \n"
                unicode"   {())}}   \n",
                unicode"   ██████   \n"
                unicode"  ██ ██ ██  \n"
                unicode" █ ██████ █ \n",
                unicode"    ████    \n"
                unicode"   ██◙◙██   \n"
                unicode"   ┌─▼▼─┐   \n",
                unicode"   ╓╖  ╓╖   \n"
                unicode"  °╜╚╗╔╝╙°  \n"
                unicode"   ┌─╨╨─┐   \n",
                unicode"   ± ±± ±   \n"
                unicode"   ◙◙◙◙◙◙   \n"
                unicode"   ┌────┐   \n",
                unicode"  ♫     ♪   \n"
                unicode"    ♪     ♫ \n"
                unicode" ♪ ┌────┐   \n",
                unicode"    /≡≡\\    \n"
                unicode"   /≡≡≡≡\\   \n"
                unicode"  /┌────┐\\  \n",
                unicode"            \n"
                unicode"   ♣♥♦♠♣♥   \n"
                unicode"   ┌────┐   \n",
                unicode"     [⌂]    \n"
                unicode"      │     \n"
                unicode"   ┌────┐   \n",
                unicode"  /\\/\\/\\/\\  \n"
                unicode"  \\\\/\\/\\//  \n"
                unicode"   ┌────┐   \n",
                unicode"    ↑↑↓↓    \n"
                unicode"   ←→←→AB   \n"
                unicode"   ┌────┐   \n",
                unicode"    ┌─┬┐    \n"
                unicode"   ┌┘┌┘└┐   \n"
                unicode"   ├─┴──┤   \n",
                unicode"    ☼  ☼    \n"
                unicode"     \\/     \n"
                unicode"   ┌────┐   \n"
            ];
        uint256 topId = rand % 56;
        return tops[topId];
    }
}
