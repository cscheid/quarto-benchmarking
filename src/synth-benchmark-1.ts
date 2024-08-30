const workFactor = Deno.args[0] ? parseInt(Deno.args[0]) : 1;

console.log(`
---
title: "benchmarking pandoc + quarto"
---
`);

const lorem = `\nLorem ipsum dolor sit amet, consectetur adipiscing elit
Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris 
nisi ut aliquip ex ea commodo consequat.`;

for (let i = 0; i < workFactor; ++i) {
    console.log(lorem);
}