import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

dotenv.config();

const prisma = new PrismaClient();

async function migrateDatabaseData() {
  console.log('Starting migration of legacy data (royals -> ghadir) in the database...');
  try {
    const users = await prisma.user.findMany();
    let updatedCount = 0;

    for (const u of users) {
      let email = u.email;
      let password = u.password;
      let changed = false;

      if (email.includes('royals')) {
        email = email.replace(/royals_/g, 'ghadir_').replace(/@royals\.sa/g, '@ghadirsports.sa');
        changed = true;
      }

      if (password.includes('royals') || password.includes('Royals') || password.includes('Royal')) {
        password = password.replace(/royals_/g, 'ghadir_').replace(/Royals@/g, 'Ghadir@').replace(/Royal@/g, 'Ghadir@');
        changed = true;
      }

      if (changed) {
        // Check for email collision before updating
        const duplicate = await prisma.user.findFirst({
          where: { email, NOT: { id: u.id } }
        });

        if (!duplicate) {
          await prisma.user.update({
            where: { id: u.id },
            data: { email, password }
          });
          updatedCount++;
          console.log(`Updated User ID ${u.id}: ${u.email} -> ${email}`);
        } else {
          console.log(`Skipping duplicate email for User ID ${u.id}: ${email}`);
        }
      }
    }

    console.log(`Successfully migrated ${updatedCount} user record(s) in PostgreSQL database.`);
  } catch (error) {
    console.error('Migration failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

migrateDatabaseData();
