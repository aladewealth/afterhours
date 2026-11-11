import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    remotePatterns: [
      { protocol: "https", hostname: "metadata.coinbase.com" },
      { protocol: "https", hostname: "api.coinbase.com" },
    ],
  },
};

export default nextConfig;
